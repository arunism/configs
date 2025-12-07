#!/bin/bash
# Launch tools based on Hyprland user defaults

config="$HOME/.config/hypr/defaults.conf"

# Ensure config exists
[[ -f "$config" ]] || { echo "Config not found"; exit 1; }

# Clean and load config (remove $ and fix spacing)
eval "$(sed 's/\$//g; s/ = /=/' "$config")"

# Ensure terminal is set
[[ -n "$terminal" ]] || { echo "\$termnal not set in config"; exit 1; }

# Handle actions
case "$1" in
    --btop)   $terminal --title btop   sh -c 'btop' ;;
    --nvtop)  $terminal --title nvtop  sh -c 'nvtop' ;;
    --nmtui)  $terminal nmtui ;;
    --term)   $terminal & ;;
    --files)  $fileManager & ;;
    *)
        echo "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
        ;;
esac

