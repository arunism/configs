#!/bin/bash
# System sound helper (used by volume.sh & screenshot.sh)

theme="freedesktop"
mute=false
muteScreenshots=false
muteVolume=false

# Global mute
[[ "$mute" = true ]] && exit 0

# ---- Select sound ----
case "$1" in
    --screenshot)
        [[ "$muteScreenshots" = true ]] && exit 0
        sound="screen-capture.*"
        ;;
    --volume)
        [[ "$muteVolume" = true ]] && exit 0
        sound="audio-volume-change.*"
        ;;
    --error)
        sound="dialog-error.*"
        ;;
    *)
        echo "Sounds: --screenshot | --volume | --error"
        exit 0
        ;;
esac

# ---- Sound directories ----
if [[ -d "/run/current-system/sw/share/sounds" ]]; then
    systemDIR="/run/current-system/sw/share/sounds"   # NixOS
else
    systemDIR="/usr/share/sounds"
fi

userDIR="$HOME/.local/share/sounds"
defaultTheme="freedesktop"

# Pick theme (user → system → default)
if [[ -d "$userDIR/$theme" ]]; then
    sDIR="$userDIR/$theme"
elif [[ -d "$systemDIR/$theme" ]]; then
    sDIR="$systemDIR/$theme"
else
    sDIR="$systemDIR/$defaultTheme"
fi

# Inherited theme directory
iTheme=$(grep -i "inherits" "$sDIR/index.theme" | cut -d= -f2)
iDIR="$sDIR/../$iTheme"

# ---- Locate sound ----
find_sound() {
    find -L "$1/stereo" -name "$sound" -print -quit
}

sound_file=$(find_sound "$sDIR" \
        || find_sound "$iDIR" \
        || find_sound "$userDIR/$defaultTheme" \
        || find_sound "$systemDIR/$defaultTheme")

[[ -z "$sound_file" ]] && { echo "Sound not found"; exit 1; }

# ---- Play ----
pw-play "$sound_file" || pa-play "$sound_file"
