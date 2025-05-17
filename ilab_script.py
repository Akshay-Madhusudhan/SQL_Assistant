#!/usr/bin/env python3
import sys
import psycopg2
import pandas as pd
from io import StringIO

# PostgreSQL connection parameters
# Update these with your actual database credentials
DB_HOST = "postgres.cs.rutgers.edu"
DB_NAME = "am3197"
DB_USER = "am3197"
DB_PORT = 5432

def execute_query(query):
    """Execute the given SQL query and return the results"""
    try:
        # Connect to PostgreSQL database
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            port=DB_PORT
        )
        
        # Create a cursor
        cursor = conn.cursor()
        
        # Execute the query
        cursor.execute(query)
        
        # Fetch column names
        col_names = [desc[0] for desc in cursor.description]
        
        # Fetch all rows
        rows = cursor.fetchall()
        
        # Create DataFrame for nice formatting
        df = pd.DataFrame(rows, columns=col_names)
        
        # Close cursor and connection
        cursor.close()
        conn.close()
        
        # Return formatted output
        return df.to_string(index=False)
        
    except Exception as e:
        return f"Error executing query: {str(e)}"

def main():
    # Check if query is provided as command line argument
    if len(sys.argv) > 1:
        query = sys.argv[1]
    # Otherwise read from stdin (for extra credit)
    else:
        # Read all input from stdin
        stdin_input = sys.stdin.read().strip()
        
        if not stdin_input:
            print("No query provided. Please provide an SQL query.")
            sys.exit(1)
        
        query = stdin_input
    
    # Execute the query and print results
    results = execute_query(query)
    print(results)

if __name__ == "__main__":
    main()
