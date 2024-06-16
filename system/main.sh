# This script makes all Bash scripts in a specified directory executable.

# Ask user for directory path
read -p "Enter the directory path (leave empty for current directory): " directory

# Use current directory if user input is empty
directory="${directory:-$(pwd)}/scripts"

# Ensure the directory exists and is accessible
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' not found."
    exit 1
fi

# Find all Bash scripts in the directory and make them executable
find "$directory" -type f -name "*.sh" -exec chmod +x {} \;

echo "Executable permissions granted to all Bash scripts in '$directory'."

# Execute each Bash script found in the directory
find "$directory" -type f -name "*.sh" -exec {} \;

