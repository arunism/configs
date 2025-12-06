#!/bin/bash
# Install Battery Monitor & Set Up Low Battery Notifications

# Required packages
battery=(
  acpi
  libnotify
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install required packages
echo "Installing Battery Monitor packages..."
for PKG in "${battery[@]}"; do
  install_package "$PKG"
done

# Create battery monitoring script
echo "Creating battery monitoring script..."

BATTERY_SCRIPT="$HOME/.config/hypr/scripts/battery-monitor.sh"
mkdir -p "$HOME/.config/hypr/scripts"

cat > "$BATTERY_SCRIPT" << 'EOF'
#!/bin/bash
# Monitors battery and sends low/critical battery notifications

LOW_BATTERY_THRESHOLD=20
CRITICAL_BATTERY_THRESHOLD=10
CHECK_INTERVAL=60  # Check every 60 seconds

NOTIFIED_LOW=false
NOTIFIED_CRITICAL=false

while true; do
    BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
    BATTERY_STATUS=$(acpi -b | grep -o 'Discharging\|Charging\|Full')
    
    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_CRITICAL" = false ]; then
            notify-send -u critical -i battery-caution "Critical Battery" "Battery level is at ${BATTERY_LEVEL}%!"
            NOTIFIED_CRITICAL=true
            NOTIFIED_LOW=true
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_LOW" = false ]; then
            notify-send -u normal -i battery-low "Low Battery" "Battery level is at ${BATTERY_LEVEL}%. Please charge soon."
            NOTIFIED_LOW=true
        fi
    else
        NOTIFIED_LOW=false
        NOTIFIED_CRITICAL=false
    fi
    
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$BATTERY_SCRIPT"
echo "Battery monitoring script created at $BATTERY_SCRIPT"

# Create systemd service for battery monitor
echo "Creating systemd service for battery monitor..."

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/battery-monitor.service" << EOF
[Unit]
Description=Battery Level Monitor
After=graphical-session.target

[Service]
Type=simple
ExecStart=$BATTERY_SCRIPT
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "Systemd service created"

# Enable and start the service
echo "Enabling and starting battery monitor service..."
systemctl --user daemon-reload
systemctl --user enable battery-monitor.service
systemctl --user start battery-monitor.service

echo "${OK} Battery monitor service is now running!"
echo "${NOTE} Check status with: systemctl --user status battery-monitor"
echo "${NOTE} Stop service: systemctl --user stop battery-monitor"
echo "${NOTE} Disable service: systemctl --user disable battery-monitor"

# Print two blank lines for readability
printf "\n%.0s" {1..2}

