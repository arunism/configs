nvidia_pkg=(
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  libva
  libva-nvidia-driver
)

# Source global functions
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# nvidia stuff
echo -e "${YELLOW} Checking for Hyprland packages...${RESET}"
if pacman -Qs hyprland > /dev/null; then
  echo -e "${YELLOW} Removing Hyprland packages...${RESET}"
  for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
    sudo pacman -R --noconfirm "$hyprnvi" || true
  done
fi

# Install Nvidia packages
echo -e "${YELLOW} Installing Nvidia packages...${RESET}"
for krnl in $(cat /usr/lib/modules/*/pkgbase); do
  for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
    install_package "$NVIDIA"
  done
done

# Add Nvidia modules to mkinitcpio.conf if not present
if ! grep -qE '^MODULES=.*nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  echo "${OK} Nvidia modules added to mkinitcpio.conf"
else
  echo "Nvidia modules already in mkinitcpio.conf"
fi

# Rebuild initramfs
echo -e "${INFO} Rebuilding initramfs...${RESET}"
sudo mkinitcpio -P

# Check for nvidia.conf and add options if missing
NVEA="/etc/modprobe.d/nvidia.conf"
if [ ! -f "$NVEA" ]; then
  echo -e "${YELLOW} Adding options to $NVEA...${RESET}"
  echo -e "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a "$NVEA"
else
  echo -e "${INFO} Options already present in $NVEA...${RESET}"
fi

# GRUB-specific steps
if [ -f /etc/default/grub ]; then
    echo -e "${INFO} GRUB bootloader detected${RESET}"

    # Add nvidia options to GRUB if not present
    if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
        echo -e "${OK} nvidia-drm.modeset=1 added to GRUB"
    fi

    if ! sudo grep -q "nvidia_drm.fbdev=1" /etc/default/grub; then
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.fbdev=1"/' /etc/default/grub
        echo -e "${OK} nvidia_drm.fbdev=1 added to GRUB"
    fi

    # Regenerate GRUB config
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo -e "${INFO} GRUB configuration updated"
fi

# systemd-boot-specific steps
if [ -f /boot/loader/loader.conf ]; then
    echo -e "${INFO} systemd-boot detected${RESET}"

    # Backup and update systemd-boot entries
    backup_count=$(find /boot/loader/entries/ -type f -name "*.conf.bak" | wc -l)
    conf_count=$(find /boot/loader/entries/ -type f -name "*.conf" | wc -l)

    if [ "$backup_count" -ne "$conf_count" ]; then
        find /boot/loader/entries/ -type f -name "*.conf" | while read imgconf; do
            sudo cp "$imgconf" "$imgconf.bak"
            echo -e "${INFO} Backup created for $imgconf"

            # Update with Nvidia settings
            sdopt=$(grep -w "^options" "$imgconf" | sed 's/\b nvidia-drm.modeset=[^ ]*\b//g' | sed 's/\b nvidia_drm.fbdev=[^ ]*\b//g')
            sudo sed -i "/^options/c${sdopt} nvidia-drm.modeset=1 nvidia_drm.fbdev=1" "$imgconf"
        done

        echo -e "${OK} systemd-boot updated"
    else
        echo -e "${NOTE} systemd-boot already configured"
    fi
fi

echo -e "\nInstallation complete."
