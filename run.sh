#!/bin/bash

# Add the user to the 'input' group
sudo usermod -aG input "$(whoami)"

# Get the current script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/scripts"

# Source the all scripts located in the same directory
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/audio.sh"
source "$SCRIPT_DIR/bluetooth.sh"
source "$SCRIPT_DIR/sddm.sh"

