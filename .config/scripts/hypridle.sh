#!/bin/bash
# Custom idle inhibitor for Waybar (uses hypridle)

PROCESS="hypridle"

case "$1" in
    status)
        sleep 1
        if pgrep -x "$PROCESS" >/dev/null; then
            echo '{"text":"RUNNING","class":"active","tooltip":"idle_inhibitor NOT ACTIVE\nLeft Click: Activate\nRight Click: Lock Screen"}'
        else
            echo '{"text":"NOT RUNNING","class":"notactive","tooltip":"idle_inhibitor ACTIVE\nLeft Click: Deactivate\nRight Click: Lock Screen"}'
        fi
        ;;
    toggle)
        if pgrep -x "$PROCESS" >/dev/null; then
            pkill "$PROCESS"
        else
            "$PROCESS"
        fi
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac

