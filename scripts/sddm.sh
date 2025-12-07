# Packages for SDDM and its dependencies
sddm=(
  qt6-declarative 
  qt6-svg
  qt6-virtualkeyboard
  qt6-multimedia-ffmpeg
  sddm
)

# Login managers to disable if found
login=(
  lightdm 
  gdm3 
  gdm 
  lxdm 
  lxdm-gtk3
  display-manager
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install required packages
echo "Installing SDDM and dependencies..."
for package in "${sddm[@]}"; do
  install_package "$package"
done

# Disable other login managers if installed
for manager in "${login[@]}"; do
  if pacman -Qs "$manager" > /dev/null 2>&1; then
    echo "Disabling $manager..."
    sudo systemctl disable "$manager.service" --now || true
  fi
done

# Ensure SDDM is enabled
echo "Enabling SDDM..."
sudo systemctl enable sddm.service

# Check and create Wayland sessions directory if missing
wayland_sessions_dir="/usr/share/wayland-sessions"
if [ ! -d "$wayland_sessions_dir" ]; then
  echo "Creating Wayland sessions directory..."
  sudo mkdir "$wayland_sessions_dir"
fi


# SDDM Theme Setup
theme_name="sddm"

# Install and configure the SDDM theme
echo "Installing SDDM theme..."

# Remove any existing theme directory
if [ -d "/usr/share/sddm/themes/$theme_name" ]; then
  sudo rm -rf "/usr/share/sddm/themes/$theme_name"
  echo "Removed existing $theme_name theme directory."
fi

# Ensure the themes directory exists
[ ! -d "/usr/share/sddm/themes" ] && sudo mkdir -p /usr/share/sddm/themes

# Move the theme to the system themes directory
sudo cp -r "$(pwd)/$theme_name" "/usr/share/sddm/themes/$theme_name"

# Configure SDDM to use the new theme
sddm_conf="/etc/sddm.conf"
BACKUP_SUFFIX=".bak"

echo "Setting up the login screen..."

# Backup or create sddm.conf
if [ -f "$sddm_conf" ]; then
  sudo cp "$sddm_conf" "$sddm_conf$BACKUP_SUFFIX"
else
  sudo touch "$sddm_conf"
fi

# Update or add the [Theme] section
if grep -q '^\[Theme\]' "$sddm_conf"; then
  sudo sed -i "/^\[Theme\]/,/^\[/{s/^\s*Current=.*/Current=$theme_name/}" "$sddm_conf"
else
  echo -e "\n[Theme]\nCurrent=$theme_name" | sudo tee -a "$sddm_conf" > /dev/null
fi

# Add [General] section with InputMethod
if ! grep -q '^\[General\]' "$sddm_conf"; then
  echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a "$sddm_conf" > /dev/null
else
  sudo sed -i '/^\[General\]/,/^\[/{s/^\s*InputMethod=.*/InputMethod=qtvirtualkeyboard/}' "$sddm_conf"
fi

# Update the background image
# sudo cp -r assets/sddm.png "/usr/share/sddm/themes/$theme_name/Backgrounds/default"
# sudo sed -i 's|^wallpaper=".*"|wallpaper="Backgrounds/default"|' "/usr/share/sddm/themes/$theme_name/theme.conf"

echo "Theme $theme_name installed successfully."

# Print two blank lines for readability
printf "\n%.0s" {1..2}

