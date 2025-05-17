import os
import re
import sys
import time
import getpass
import paramiko
from pathlib import Path
# ==== Will take a while for sql query to generate ====
# For GPT4ALL integration
from gpt4all import GPT4All

# Schema file - extract from the full SQL script
SCHEMA_FILE = "output.txt"

# GPT4ALL model file path - update as needed
# Use a model that's available in the GPT4ALL library to first create the models directory, then place Phi model in that directory (should be in Users/youruser/.cache/gpt4all/models)
# Recommended to use mistral however, as it is a better model for SQL querying
MODEL_NAME = "mistral-7b-instruct-v0.1.Q4_0.gguf"
# "Phi-3.5-mini-instruct-Q4_K_M.gguf"


# ILAB connection details
ILAB_HOST = "ilab1.cs.rutgers.edu"
REMOTE_SCRIPT_PATH = "/common/home/am3197/Downloads/ilab_script.py"  # Path to the script on ILAB

def load_schema():
    """Load the database schema from file"""
    try:
        with open(SCHEMA_FILE, 'r') as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: Schema file '{SCHEMA_FILE}' not found.")
        sys.exit(1)

def extract_table_info(schema):
    """Extract table names and their columns from the schema"""
    tables = {}
    current_table = None
    
    # Simple regex-based parsing of CREATE TABLE statements
    for line in schema.split('\n'):
        line = line.strip()
        
        # Look for CREATE TABLE statements
        if line.startswith('CREATE TABLE'):
            # Extract table name
            match = re.match(r'CREATE TABLE (\w+)\(', line)
            if match:
                current_table = match.group(1)
                tables[current_table] = []
            else:
                # Try alternate format
                match = re.match(r'CREATE TABLE (\w+)\s*\(', line)
                if match:
                    current_table = match.group(1)
                    tables[current_table] = []
        
        # Capture column definitions
        elif current_table and line and not line.startswith(')') and not line.startswith('CREATE'):
            # Extract column name and type
            col_match = re.match(r'\s*(\w+)\s+([\w\(\)]+),?', line)
            if col_match:
                column_name = col_match.group(1)
                column_type = col_match.group(2)
                tables[current_table].append((column_name, column_type))
    
    return tables

def setup_llm():
    """Initialize the GPT4ALL model"""
    try:
        # Make MODEL_NAME accessible for modification
        global MODEL_NAME
        
        # GPT4All will automatically download the model if not present
        print(f"Initializing GPT4ALL with model: {MODEL_NAME}")
        
        # List available models - using the correct API
        print("Available models from GPT4ALL:")
        try:
            # For newer versions of gpt4all
            available_models = GPT4All.list_models()
            
            # Display models
            for i, model in enumerate(available_models[:5]):  # Show first 5 models
                print(f"  {i+1}. {model['filename'] if isinstance(model, dict) else model}")
            print("  ... and more")
            
            # Allow user to select a model
            choice = input("\nUse default model or choose another? (default/choose): ").strip().lower()
            if choice == "choose":
                print("\nEnter the number of a model from the list above,")
                print("or type the full model name if you know it:")
                model_choice = input("> ").strip()
                
                try:
                    # Check if input is a number (index)
                    idx = int(model_choice) - 1
                    if 0 <= idx < len(available_models):
                        if isinstance(available_models[idx], dict):
                            MODEL_NAME = available_models[idx]['filename']
                        else:
                            MODEL_NAME = available_models[idx]
                        print(f"Selected model: {MODEL_NAME}")
                except ValueError:
                    # Input is a string (model name)
                    MODEL_NAME = model_choice
                    print(f"Using specified model: {MODEL_NAME}")
        except (AttributeError, ImportError):
            # Fallback for older versions or if list_models is not available
            print("  Could not retrieve model list.")
            print("  Using default model or specify your own.")
            print(f"  Current model: {MODEL_NAME}")
            
            # Simple option to specify a different model
            choice = input("\nUse default model or enter another model name? (default/enter): ").strip().lower()
            if choice != "default":
                MODEL_NAME = input("Enter model name: ").strip()
                print(f"Using model: {MODEL_NAME}")
        
        # Initialize the model
        model = GPT4All(model_name=MODEL_NAME)
        
        return model
    except Exception as e:
        print(f"Error initializing GPT4ALL: {str(e)}")
        print("\nTroubleshooting tips:")
        print("1. Check your internet connection")
        print("2. Visit https://gpt4all.io/index.html to see available models")
        print("3. Try a different model name")
        print("4. If this is the first run, GPT4ALL needs to download the model (~1-4GB)")
        
        # List some known working models as suggestions
        print("\nSome known working models to try:")
        print("- orca-mini-3b-gguf2-q4_0.gguf")
        print("- gpt4all-falcon-q4_0.gguf")
        print("- mistral-7b-instruct-v0.1.Q4_0.gguf")
        print("- llama-2-7b-chat.ggmlv3.q4_0.bin")
        
        sys.exit(1)

def create_prompt(schema, question):
    """Create a prompt for the LLM based on the schema and user question"""
    return f"""
## Database Schema:
```sql
{schema}
```

## User Question:
{question}

DO NOT USE BACKTICKS and/or markdown of any kind.
Do not include comments and/or explanations of any kind.
Preliminary has null values and empty strings, be sure to prevent errors from them when querying.
Query ONLY from the Races, CoRaces, or Denials table when querying for quantitative data about applicant race, co_applicant race, and denial reasons.
For example: If you want to find the most common loan denial reason, then the query would be SELECT denial_reason, COUNT(*) AS count FROM Denials GROUP BY denial_reason ORDER BY count DESC LIMIT 1;.
ONLY USE TABLE AND THEIR RESPECTIVE COLUMN NAMES IN THE SCHEMA PROVIDED.
Provide a correct and valid sql query:
"""

def extract_sql_query(llm_response):
    """Extract just the SQL query from the LLM response"""
    # Attempt to extract query with better pattern matching
    # Look for SQL patterns like SELECT, FROM, etc.
    sql_pattern = r"(?:SELECT|WITH|WITH\s+RECURSIVE)[^;]*(?:;)?"
    match = re.search(sql_pattern, llm_response, re.IGNORECASE | re.DOTALL)
    
    if match:
        query = match.group(0).strip()
        # Add semicolon if missing
        if not query.endswith(';'):
            query += ';'
        return query
    
    # Fallback: return the whole response if no clear SQL pattern is found
    # Remove any markdown code blocks if present
    cleaned = re.sub(r'```(?:sql)?(.*?)```', r'\1', llm_response, flags=re.DOTALL)
    return cleaned.strip()

def connect_to_ilab(username, password):
    """Establish SSH connection to ILAB"""
    try:
        # Create SSH client
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Connect to ILAB
        print(f"Connecting to {ILAB_HOST}...")
        client.connect(
            hostname=ILAB_HOST,
            username=username,
            password=password
        )
        
        return client
    except Exception as e:
        print(f"Error connecting to ILAB: {str(e)}")
        return None

def execute_query_on_ilab(ssh_client, query):
    """Execute SQL query on ILAB and return results"""
    try:
        print(query)
        # Execute the remote script with the query
        command = f'python3 {REMOTE_SCRIPT_PATH} "{query}"'
        
        # Execute command
        stdin, stdout, stderr = ssh_client.exec_command(command)
        
        # Read output
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')
        
        if error:
            return f"Error: {error}"
        
        return output
    except Exception as e:
        return f"Error executing query: {str(e)}"

def main():
    # Load schema
    schema = load_schema()
    
    # Setup GPT4ALL model
    print("Initializing GPT4ALL...")
    model = setup_llm()
    
    # Get ILAB credentials
    username = input("Enter your ILAB username: ")
    password = getpass.getpass("Enter your ILAB password: ")
    
    # Connect to ILAB
    ssh_client = connect_to_ilab(username, password)
    if not ssh_client:
        print("Failed to connect to ILAB. Exiting.")
        sys.exit(1)
    
    print("Connected to ILAB successfully.")
    print("\nSQL Assistant is ready! Type 'exit' to quit.\n")
    
    # Main interaction loop
    while True:
        # Get user question
        question = input("\nEnter your question (or type 'exit' to quit): ")
        
        # Check if user wants to exit
        if question.strip().lower() == "exit":
            print("Exiting SQL Assistant.")
            break
        
        # Generate SQL query with GPT4ALL
        print("Generating SQL query...")
        prompt = create_prompt(schema, question)
        
        # Get response from GPT4ALL
        response = model.generate(
            prompt=prompt,
            max_tokens=200,
            temp=0.2
        )
        
        # Extract SQL query from response
        sql_query = extract_sql_query(response)
        
        print("\nGenerated SQL Query:")
        print("-" * 50)
        print(sql_query)
        print("-" * 50)
        
        # Execute query on ILAB
        print("\nExecuting query on database...")
        result = execute_query_on_ilab(ssh_client, sql_query)
        
        print("\nQuery Result:")
        print("=" * 80)
        print(result)
        print("=" * 80)
    
    # Close SSH connection
    ssh_client.close()

if __name__ == "__main__":
    main()