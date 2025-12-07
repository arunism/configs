#!/bin/bash
# Simple system update helper

iDIR="$HOME/.config/swaync/images"

# Require kitty
if ! command -v kitty &>/dev/null; then
    notify-send -i "$iDIR/error.png" "Kitty not found" "Install the kitty terminal."
    exit 1
fi

# Update functions
update() {
    kitty -T update "$@"
    notify-send -i "$iDIR/ja.png" -u low "$1 update" "System updated."
}

# Detect distro + update
if command -v paru &>/dev/null; then
    update paru -Syu
elif command -v yay &>/dev/null; then
    update yay -Syu
elif command -v dnf &>/dev/null; then
    update sudo dnf update --refresh -y
elif command -v apt &>/dev/null; then
    update sudo apt update && sudo apt upgrade -y
elif command -v zypper &>/dev/null; then
    update sudo zypper dup -y
else
    notify-send -i "$iDIR/error.png" -u critical "Unsupported distro"
    exit 1
fi

