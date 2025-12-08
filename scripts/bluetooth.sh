# List of essential bluetooth packages to install
blue=(
  bluez
  bluez-utils
  blueman
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install Bluetooth packages
echo "Installing Bluetooth packages..."
for BLUE in "${blue[@]}"; do
  install_package "$BLUE"
done

# Activate Bluetooth services
echo "Activating Bluetooth services..."
sudo systemctl enable --now bluetooth.service

# End of script
echo -e "\n${OK} Bluetooth setup complete!"

# Create bluetooth monitoring script
echo "Creating bluetooth monitoring script..."

BLUETOOTH_SCRIPT="$HOME/.config/scripts/bluetooth-monitor.sh"
mkdir -p "$HOME/.config/scripts"

cat > "$BLUETOOTH_SCRIPT" << 'EOF'
#!/bin/bash
# Monitors bluetooth and sends connected/disconnected device notifications

bluetoothctl monitor | while read -r line; do
    # Check if a device was connected
    if [[ "$line" =~ "Device" && "$line" =~ "Connected: yes" ]]; then
        device=$(echo "$line" | grep -oP '(?<=Device ).*(?= Connected: yes)')
        notify-send "Bluetooth Connected" "Device $device connected."

    # Check if a device was disconnected
    elif [[ "$line" =~ "Device" && "$line" =~ "Connected: no" ]]; then
        device=$(echo "$line" | grep -oP '(?<=Device ).*(?= Connected: no)')
        notify-send "Bluetooth Disconnected" "Device $device disconnected."
    fi
done

EOF

chmod +x "$BLUETOOTH_SCRIPT"
echo "Bluetooth device monitoring script created at $BLUETOOTH_SCRIPT"

# Create systemd service for bluetooth monitor
echo "Creating systemd service for bluetooth device monitor..."

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/bluetooth-monitor.service" << EOF
[Unit]
Description=Bluetooth Device Monitor
After=graphical-session.target

[Service]
Type=simple
ExecStart=$BLUETOOTH_SCRIPT
Restart=always

[Install]
WantedBy=default.target
EOF

echo "Systemd service created"

# Enable and start the service
echo "Enabling and starting bluetooth device monitor service..."
systemctl --user daemon-reload
systemctl --user enable bluetooth-monitor.service
systemctl --user start bluetooth-monitor.service

echo "${OK} Bluetooth device monitor service is now running!"
echo "${NOTE} Stop service: systemctl --user stop bluetooth-monitor"
echo "${NOTE} Disable service: systemctl --user disable bluetooth-monitor"

# Print two blank lines for readability
printf "\n%.0s" {1..2}
