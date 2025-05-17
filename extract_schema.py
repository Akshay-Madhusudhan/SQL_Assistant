#!/usr/bin/env python3
import re
import sys

def extract_schema_from_full_sql(input_file, output_file):
    """
    Extract just the CREATE TABLE statements and sample INSERT statements
    from the full SQL script
    """
    try:
        with open(input_file, 'r') as f:
            full_sql = f.read()
        
        # Extract all CREATE TABLE statements
        create_table_pattern = r'CREATE TABLE .*?;'
        create_tables = re.findall(create_table_pattern, full_sql, re.DOTALL)
        
        # Extract a sample of INSERT statements for each table
        # First, get all table names
        table_names = re.findall(r'CREATE TABLE (\w+)', full_sql)
        
        # Collect sample INSERT statements
        sample_inserts = []
        for table in table_names:
            # Find INSERT statements for this table
            insert_pattern = r'INSERT INTO ' + table + r'.*?;'
            inserts = re.findall(insert_pattern, full_sql, re.DOTALL)
            
            # Take up to 3 sample inserts per table
            if inserts:
                sample_inserts.extend(inserts[:3])
        
        # Combine and write to output file
        with open(output_file, 'w') as f:
            f.write("-- Database Schema (CREATE TABLES)\n\n")
            for create_stmt in create_tables:
                f.write(create_stmt + "\n\n")
            
            f.write("-- Sample Data (INSERT Statements)\n\n")
            for insert_stmt in sample_inserts:
                f.write(insert_stmt + "\n\n")
                
        print(f"Schema extracted successfully to {output_file}")
        
    except Exception as e:
        print(f"Error extracting schema: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python extract_schema.py <input_sql_file> <output_file>")
        sys.exit(1)
        
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    extract_schema_from_full_sql(input_file, output_file)
