#!/bin/bash

# This script splits a file containing multiple source files (marked with file path comments)
# into individual files within a project structure.

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <parent_dir>"
    echo "Example: $0 code.txt /path/to/monorepo/aws"
    exit 1
fi

input_file="$1"
parent_dir="$2"
project_dir="resource-auditor"
full_project_path="$parent_dir/$project_dir"

# Ensure the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found"
    exit 1
fi

# Create the project root directory
mkdir -p "$full_project_path"
echo "Creating new tool in $full_project_path"

# First pass: collect all directories we need to create
echo "Creating directory structure..."
directories=$(grep '^# ' "$input_file" | sed 's/^# //' | xargs -n1 dirname | sort -u)

# Create all needed directories
for dir in $directories; do
    mkdir -p "$full_project_path/$dir"
    echo "Created directory: $dir"
done

# Second pass: create all files
echo "Creating files..."
current_file=""
while IFS= read -r line; do
    if [[ $line =~ ^#[[:space:]]([[:alnum:]\/._-]+)$ ]]; then
        # Found a new file marker
        current_file="$full_project_path/${BASH_REMATCH[1]}"
        echo "Creating: ${BASH_REMATCH[1]}"
        # Clear the file if it exists
        > "$current_file"
    elif [ -n "$current_file" ]; then
        # Append content to current file
        echo "$line" >> "$current_file"
    fi
done < "$input_file"

# Check if the script executed successfully
if [ $? -eq 0 ]; then
    echo
    echo "Project files have been created successfully in $full_project_path/"
    echo
    echo "Your new tool is ready! Here's how to get started:"
    echo "  cd $full_project_path"
    echo "  python -m venv .venv"
    echo "  source .venv/bin/activate  # On Windows: venv\\Scripts\\activate"
    echo "  pip install -e ."
    echo "  pip install -r requirements-dev.txt"
    echo "  pytest tests/"
else
    echo "Error: Failed to process input file"
    exit 1
fi
