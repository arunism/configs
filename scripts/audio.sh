# List of essential Pipewire packages to install
PIPEWIRE_PACKAGES=(
    pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    sof-firmware
)

# Additional Pipewire package for forced reinstallation (based on reports)
FORCE_REINSTALL_PACKAGES=(
    pipewire-pulse
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Disable PulseAudio to avoid conflicts
echo -e "${NOTE} Disabling PulseAudio..."
systemctl --user disable --now pulseaudio.socket pulseaudio.service || true

# Install the main Pipewire packages
echo -e "${NOTE} Installing Pipewire packages..."
for PACKAGE in "${PIPEWIRE_PACKAGES[@]}"; do
    install_package "$PACKAGE"
done

# Force reinstall specific packages if needed
for PACKAGE in "${FORCE_REINSTALL_PACKAGES[@]}"; do
    install_package_pacman "$PACKAGE"
done

# Enable and start Pipewire services
echo -e "${NOTE} Starting Pipewire services..."
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl --user enable --now pipewire.service

# Completion message
echo -e "\n${OK} Pipewire setup complete!"

# Print two blank lines for readability
printf "\n%.0s" {1..2}

