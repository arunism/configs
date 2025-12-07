#!/bin/bash
# Toggle Hyprland blur level

notif="$HOME/.config/swaync/images"

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "$STATE" -eq 2 ]; then
    # Switch to low blur
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 1
    notify-send -e -u low -i "$notif/note.png" "Low Blur"
else
    # Switch to normal blur
    hyprctl keyword decoration:blur:size 5
    hyprctl keyword decoration:blur:passes 2
    notify-send -e -u low -i "$notif/ja.png" "Normal Blur"
fi
