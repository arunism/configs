#!/bin/bash
# wlogout launcher (auto-scales by resolution)

# Base values per resolution tier
A_2160=600; B_2160=600
A_1600=400; B_1600=400
A_1440=400; B_1440=400
A_1080=200; B_1080=200
A_720=50;  B_720=50

# Toggle if already running
if pgrep -x wlogout >/dev/null; then
    pkill -x wlogout
    exit 0
fi

# Get focused monitor info
resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused) | .height / .scale' | cut -d. -f1)
scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused) | .scale')

# Simple function to compute scaled values
calc() { awk "BEGIN {printf \"%.0f\", $1 * $2 * $scale / $resolution}"; }

# Tier selection
if   (( resolution >= 2160 )); then
    A=$A_2160; B=$B_2160; msg="4K+"
    flags="-b 6"
elif (( resolution >= 1600 )); then
    A=$A_1600; B=$B_1600; msg="1600p+"
    flags="-b 6"
elif (( resolution >= 1440 )); then
    A=$A_1440; B=$B_1440; msg="1440p"
    flags="-b 6"
elif (( resolution >= 1080 )); then
    A=$A_1080; B=$B_1080; msg="1080p"
    flags="-b 6"
elif (( resolution >= 720 )); then
    A=$A_720;  B=$B_720;  msg="720p"
    flags="-b 3"
else
    echo "Using default settings"
    wlogout &
    exit 0
fi

# Compute scaled margins
T=$(calc $A ${resolution})
Bv=$(calc $B ${resolution})

echo "wlogout: $msg settings"
wlogout --protocol layer-shell $flags -T "$T" -B "$Bv" &
