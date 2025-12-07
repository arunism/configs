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

# Print two blank lines for readability
printf "\n%.0s" {1..2}
