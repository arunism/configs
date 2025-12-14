# Required package
disk=(
  libnotify
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install required packages
echo "Installing Disk Monitor package..."
for PKG in "${disk[@]}"; do
  install_package "$PKG"
done

# Create disk monitoring script
echo "Creating disk space monitoring script..."

DISK_SCRIPT="$HOME/.config/scripts/disk.sh"
mkdir -p "$HOME/.config/scripts"

cat > "$DISK_SCRIPT" << 'EOF'
#!/bin/bash
# Monitors disk usage and sends notifications

DISK_WARNING_THRESHOLD=80
DISK_CRITICAL_THRESHOLD=90
CHECK_INTERVAL=300  # Check every 5 minutes

declare -A NOTIFIED_WARNING
declare -A NOTIFIED_CRITICAL

while true; do
    df -h | grep '^/dev/' | while read -r line; do
        DEVICE=$(echo "$line" | awk '{print $1}')
        MOUNT=$(echo "$line" | awk '{print $6}')
        USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')

        if ! [[ "$USAGE" =~ ^[0-9]+$ ]]; then
            continue
        fi

        if [ "$USAGE" -ge "$DISK_CRITICAL_THRESHOLD" ]; then
            if [ "${NOTIFIED_CRITICAL[$MOUNT]}" != "true" ]; then
                notify-send -u critical -i drive-harddisk "Critical Disk Space" "Mount point $MOUNT is ${USAGE}% full!\nDevice: $DEVICE"
                NOTIFIED_CRITICAL[$MOUNT]="true"
                NOTIFIED_WARNING[$MOUNT]="true"
            fi
        elif [ "$USAGE" -ge "$DISK_WARNING_THRESHOLD" ]; then
            if [ "${NOTIFIED_WARNING[$MOUNT]}" != "true" ]; then
                notify-send -u normal -i drive-harddisk "Low Disk Space" "Mount point $MOUNT is ${USAGE}% full\nDevice: $DEVICE"
                NOTIFIED_WARNING[$MOUNT]="true"
            fi
        else
            if [ "$USAGE" -lt $((DISK_WARNING_THRESHOLD - 5)) ]; then
                NOTIFIED_WARNING[$MOUNT]="false"
                NOTIFIED_CRITICAL[$MOUNT]="false"
            fi
        fi
    done

    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$DISK_SCRIPT"
echo "Disk monitoring script created at $DISK_SCRIPT"

# Create systemd service for disk monitor
echo "Creating systemd service for disk monitor..."

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/disk-monitor.service" << EOF
[Unit]
Description=Disk Space Monitor
After=graphical-session.target

[Service]
Type=simple
ExecStart=$DISK_SCRIPT
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "Systemd service created"

# Enable and start the service
echo "Enabling and starting disk monitor service..."
systemctl --user daemon-reload
systemctl --user enable disk-monitor.service
systemctl --user start disk-monitor.service

echo "${OK} Disk monitor service is now running!"
echo "${NOTE} Check status with: systemctl --user status disk-monitor"
echo "${NOTE} View disk usage with: df -h"

# Print two blank lines for readability
printf "\n%.0s" {1..2}
