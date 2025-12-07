#!/bin/bash

# Brightness control (via brightnessctl)

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000
step=10  # adjustment step

# Return current brightness (0–100)
get_brightness() {
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

# Pick icon based on brightness (rounded to nearest 20)
get_icon_path() {
    local b=$1
    local level=$(( (b + 19) / 20 * 20 ))
    (( level > 100 )) && level=100
    echo "$iDIR/brightness-${level}.png"
}

# Show brightness notification
send_notification() {
    local b=$1
    local icon=$2
    notify-send -e \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -h int:value:"$b" \
        -u low \
        -i "$icon" \
        "Brightness" "${b}%"
}

# Apply brightness change
change_brightness() {
    local delta=$1
    local cur new icon

    cur=$(get_brightness)
    new=$((cur + delta))

    # enforce min/max
    (( new < 5 )) && new=5
    (( new > 100 )) && new=100

    brightnessctl set "${new}%"

    icon=$(get_icon_path "$new")
    send_notification "$new" "$icon"
}

# Main control
case "$1" in
    --get) get_brightness ;;
    --inc) change_brightness "$step" ;;
    --dec) change_brightness "-$step" ;;
    *)     get_brightness ;;
esac

