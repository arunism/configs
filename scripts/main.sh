#!/bin/bash

# Create Install Logs directory if it doesn't exist
mkdir -p Install-Logs

# Get the current script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source the all scripts located in the same directory
source "$SCRIPT_DIR/audio.sh"
