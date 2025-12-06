#!/bin/bash

# Get the current script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/scripts"

# Source the all scripts located in the same directory
source "$SCRIPT_DIR/sddm.sh"
source "$SCRIPT_DIR/audio.sh"
source "$SCRIPT_DIR/bluetooth.sh"

