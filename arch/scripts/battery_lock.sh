#!/bin/bash

# Battery Monitor Script with Auto-Lock
# Monitors battery level and locks screen when battery is low

# Configuration
THRESHOLD=7
CHECK_INTERVAL=60
LOCKED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Find battery path
find_battery() {
    local battery_path
    
    # Look for battery devices by checking the type file
    for device in /sys/class/power_supply/*; do
        if [ -d "$device" ] && [ -f "$device/type" ]; then
            local device_type
            device_type=$(cat "$device/type" 2>/dev/null)
            if [ "$device_type" = "Battery" ]; then
                battery_path="$device"
                break
            fi
        fi
    done
    
    if [ -z "$battery_path" ]; then
        log "${RED}ERROR: No battery found in /sys/class/power_supply/${NC}"
        log "${RED}Available devices:${NC}"
        for device in /sys/class/power_supply/*; do
            if [ -d "$device" ] && [ -f "$device/type" ]; then
                local name=$(basename "$device")
                local type=$(cat "$device/type" 2>/dev/null)
                log "  $name (Type: $type)"
            fi
        done
        exit 1
    fi
    
    echo "$battery_path"
}

# Check if required commands exist
check_dependencies() {
    local missing_deps=()
    
    if ! command -v notify-send >/dev/null 2>&1; then
        missing_deps+=("notify-send (libnotify-bin)")
    fi
    
    if ! command -v hyprlock >/dev/null 2>&1; then
        missing_deps+=("hyprlock")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log "${RED}ERROR: Missing dependencies:${NC}"
        printf '%s\n' "${missing_deps[@]}"
        exit 1
    fi
}

# Get battery information
get_battery_info() {
    local battery_path="$1"
    local capacity_file="$battery_path/capacity"
    local status_file="$battery_path/status"
    
    # Check if files exist and are readable
    if [ ! -r "$capacity_file" ]; then
        log "${RED}ERROR: Cannot read battery capacity from $capacity_file${NC}"
        return 1
    fi
    
    if [ ! -r "$status_file" ]; then
        log "${RED}ERROR: Cannot read battery status from $status_file${NC}"
        return 1
    fi
    
    # Read battery level and status
    BATTERY_LEVEL=$(cat "$capacity_file" 2>/dev/null)
    BATTERY_STATUS=$(cat "$status_file" 2>/dev/null)
    
    # Validate battery level is numeric
    if ! [[ "$BATTERY_LEVEL" =~ ^[0-9]+$ ]]; then
        log "${RED}ERROR: Invalid battery level: $BATTERY_LEVEL${NC}"
        return 1
    fi
    
    return 0
}

# Send notification
send_notification() {
    local level="$1"
    local urgency="normal"
    
    if [ "$level" -le 10 ]; then
        urgency="critical"
    elif [ "$level" -le 20 ]; then
        urgency="normal"
    fi
    
    notify-send \
        --urgency="$urgency" \
        --icon="battery-caution" \
        --app-name="Battery Monitor" \
        "Low Battery Warning" \
        "Battery at ${level}%. Screen will be locked to preserve power."
}

# Lock screen
lock_screen() {
    log "${YELLOW}Locking screen due to low battery (${BATTERY_LEVEL}%)${NC}"
    
    # Try to lock with hyprlock
    if hyprlock 2>/dev/null; then
        log "${GREEN}Screen locked successfully${NC}"
        LOCKED=1
    else
        log "${RED}ERROR: Failed to lock screen with hyprlock${NC}"
        # Fallback notification
        notify-send \
            --urgency="critical" \
            --icon="battery-caution" \
            "Battery Critical" \
            "Unable to lock screen automatically. Battery at ${BATTERY_LEVEL}%"
    fi
}

# Cleanup function
cleanup() {
    log "${GREEN}Battery monitor stopped${NC}"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main function
main() {
    log "${GREEN}Starting battery monitor (threshold: ${THRESHOLD}%, interval: ${CHECK_INTERVAL}s)${NC}"
    
    # Initial checks
    check_dependencies
    local battery_path
    battery_path=$(find_battery)
    
    log "${GREEN}Using battery: $battery_path${NC}"
    
    # Main monitoring loop
    while true; do
        # Get battery information
        if ! get_battery_info "$battery_path"; then
            log "${RED}Failed to get battery info, retrying in ${CHECK_INTERVAL}s${NC}"
            sleep "$CHECK_INTERVAL"
            continue
        fi
        
        # Debug output (uncomment for verbose logging)
        # log "Battery: ${BATTERY_LEVEL}% (${BATTERY_STATUS})"
        
        # Check if we should lock the screen
        if [ "$BATTERY_LEVEL" -le "$THRESHOLD" ] && [ "$LOCKED" -eq 0 ]; then
            # Don't lock if battery is charging or full
            if [ "$BATTERY_STATUS" = "Charging" ] || [ "$BATTERY_STATUS" = "Full" ]; then
                log "${GREEN}Battery at ${BATTERY_LEVEL}% but charging/full, not locking${NC}"
            else
                log "${YELLOW}Battery low: ${BATTERY_LEVEL}% (Status: ${BATTERY_STATUS})${NC}"
                send_notification "$BATTERY_LEVEL"
                sleep 3  # Give user time to see notification
                lock_screen
            fi
        elif [ "$BATTERY_LEVEL" -gt "$THRESHOLD" ] && [ "$LOCKED" -eq 1 ]; then
            # Reset lock flag when battery is above threshold
            log "${GREEN}Battery recovered: ${BATTERY_LEVEL}%, unlocking flag${NC}"
            LOCKED=0
        fi
        
        sleep "$CHECK_INTERVAL"
    done
}

# Run main function
main "$@"
