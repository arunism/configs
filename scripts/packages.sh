# List of essential Hyprland packages to install
package_list=(
  bc
  jq
  curl
  gvfs
  gvfs-mtp
  hypridle
  hyprlock
  hyprpaper
  hyprpolkitagent
  imagemagick
  kitty
  network-manager-applet
  pamixer
  pavucontrol
  playerctl
  qt5ct
  qt6ct
  qt6-svg
  rofi
  zip
  unzip
  waybar
  wget
  ripgrep
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils
  brightnessctl
  btop
  fastfetch
  gnome-system-monitor
  nvtop
  nwg-look
  nwg-displays
  pacman-contrib
  swaync
  thunar
  thunar-volman
  tumbler
  ffmpegthumbnailer
  thunar-archive-plugin
  xarchiver
  nodejs
  npm
  google-chrome
  python-pip
  wlr-randr
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

echo -e "\n${NOTE} Installing necessary Hyprland packages..."
for PKG in "${package_list[@]}"; do
  install_package "$PKG"
done

echo -e "\n${OK} Installation complete."

# Print two blank lines for readability
printf "\n%.0s" {1..2}
