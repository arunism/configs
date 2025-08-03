#!/bin/bash

# Battery Debug Script
# Run this to see what power supply devices are available on your system

echo "=== Power Supply Debug Information ==="
echo

echo "1. Contents of /sys/class/power_supply/:"
ls -la /sys/class/power_supply/ 2>/dev/null || echo "Directory not found or not accessible"
echo

echo "2. Looking for battery-related directories:"
find /sys/class/power_supply/ -type d 2>/dev/null | grep -i bat || echo "No battery directories found"
echo

echo "3. All power supply devices:"
for device in /sys/class/power_supply/*; do
    if [ -d "$device" ]; then
        echo "Device: $(basename "$device")"
        if [ -f "$device/type" ]; then
            echo "  Type: $(cat "$device/type" 2>/dev/null)"
        fi
        if [ -f "$device/capacity" ]; then
            echo "  Capacity: $(cat "$device/capacity" 2>/dev/null)%"
        fi
        if [ -f "$device/status" ]; then
            echo "  Status: $(cat "$device/status" 2>/dev/null)"
        fi
        echo
    fi
done

echo "4. Alternative battery detection methods:"
echo

echo "Using 'acpi' command (if available):"
if command -v acpi >/dev/null 2>&1; then
    acpi -b 2>/dev/null || echo "acpi command failed"
else
    echo "acpi command not found"
fi
echo

echo "Using 'upower' command (if available):"
if command -v upower >/dev/null 2>&1; then
    upower -i $(upower -e | grep 'BAT') 2>/dev/null | grep -E "(state|percentage)" || echo "upower failed or no battery found"
else
    echo "upower command not found"
fi
echo

echo "Using 'cat /proc/acpi/battery/*/info' (if available):"
if [ -d /proc/acpi/battery ]; then
    for bat in /proc/acpi/battery/*/info; do
        if [ -f "$bat" ]; then
            echo "Found: $bat"
            cat "$bat" 2>/dev/null | head -5
        fi
    done
else
    echo "/proc/acpi/battery not found"
fi
