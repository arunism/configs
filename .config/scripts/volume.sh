#!/bin/bash
# Volume & mic control (pamixer)

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/scripts"

# --------- Helpers ---------
get_volume() {
    v=$(pamixer --get-volume)
    [[ $v -eq 0 ]] && echo "Muted" || echo "$v%"
}

get_icon() {
    v=$(get_volume)
    [[ $v == "Muted" ]] && echo "$iDIR/volume-mute.png" && return
    v=${v%%%}
    if   (( v <= 30 )); then echo "$iDIR/volume-low.png"
    elif (( v <= 60 )); then echo "$iDIR/volume-mid.png"
    else                   echo "$iDIR/volume-high.png"
    fi
}

notify_user() {
    vol=$(get_volume)
    icon=$(get_icon)

    if [[ $vol == "Muted" ]]; then
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true \
            -h string:x-canonical-private-synchronous:volume_notif \
            -i "$icon" "Volume: Muted"
    else
        val=${vol%%%}
        notify-send -e -u low \
            -h int:value:"$val" \
            -h boolean:SWAYNC_BYPASS_DND:true \
            -h string:x-canonical-private-synchronous:volume_notif \
            -i "$icon" "Volume: $vol"
        "$sDIR/sounds.sh" --volume
    fi
}

# --------- Main volume ---------
inc_volume() {
    [[ "$(pamixer --get-mute)" == "true" ]] && toggle_mute && return
    pamixer -i 5 --allow-boost --set-limit 150 && notify_user
}

dec_volume() {
    [[ "$(pamixer --get-mute)" == "true" ]] && toggle_mute && return
    pamixer -d 5 && notify_user
}

toggle_mute() {
    if [[ "$(pamixer --get-mute)" == "false" ]]; then
        pamixer -m
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true \
            -i "$iDIR/volume-mute.png" "Muted"
    else
        pamixer -u
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true \
            -i "$(get_icon)" "Volume On"
    fi
}

# --------- Microphone ---------
get_mic_volume() {
    v=$(pamixer --default-source --get-volume)
    [[ $v -eq 0 ]] && echo "Muted" || echo "$v%"
}

get_mic_icon() {
    v=$(pamixer --default-source --get-volume)
    [[ $v -eq 0 ]] && echo "$iDIR/microphone-mute.png" || echo "$iDIR/microphone.png"
}

notify_mic_user() {
    vol=$(get_mic_volume)
    icon=$(get_mic_icon)
    val=${vol%%%}
    notify-send -e -u low \
        -h int:value:"$val" \
        -h boolean:SWAYNC_BYPASS_DND:true \
        -h string:x-canonical-private-synchronous:volume_notif \
        -i "$icon" "Mic: $vol"
}

toggle_mic() {
    if [[ "$(pamixer --default-source --get-mute)" == "false" ]]; then
        pamixer --default-source -m
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true \
            -i "$iDIR/microphone-mute.png" "Mic Off"
    else
        pamixer --default-source -u
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true \
            -i "$iDIR/microphone.png" "Mic On"
    fi
}

inc_mic_volume() {
    [[ "$(pamixer --default-source --get-mute)" == "true" ]] && toggle_mic && return
    pamixer --default-source -i 5 && notify_mic_user
}

dec_mic_volume() {
    [[ "$(pamixer --default-source --get-mute)" == "true" ]] && toggle_mic && return
    pamixer --default-source -d 5 && notify_mic_user
}

# --------- Dispatcher ---------
case "$1" in
    --get)           get_volume ;;
    --inc)           inc_volume ;;
    --dec)           dec_volume ;;
    --toggle)        toggle_mute ;;
    --toggle-mic)    toggle_mic ;;
    --get-icon)      get_icon ;;
    --get-mic-icon)  get_mic_icon ;;
    --mic-inc)       inc_mic_volume ;;
    --mic-dec)       dec_mic_volume ;;
    *)               get_volume ;;
esac
