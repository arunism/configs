#!/usr/bin/env bash
set -euo pipefail

# ---------- CONSTANTS ----------
readonly THEME_NAME="sddm-aconfig-theme"
readonly THEMES_DIR="/usr/share/sddm/themes"
readonly LOCAL_THEME_DIR="$(pwd)/sddm"
readonly METADATA="$THEMES_DIR/$THEME_NAME/metadata.desktop"

# ---------- LOG HELPERS ----------
info() { echo -e "\e[32m✅ $*\e[0m"; }
warn() { echo -e "\e[33m⚠  $*\e[0m"; }
error(){ echo -e "\e[31m❌ $*\e[0m" >&2; }

# ---------- Install dependencies ----------
install_deps() {
    info "Installing dependencies (Arch Linux)..."
    sudo pacman --needed --noconfirm -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
    info "Dependencies installed"
}

# ---------- Install theme from local directory ----------
install_theme() {
    local src="$LOCAL_THEME_DIR"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$src" ]] && { error "Local theme directory 'sddm' not found next to this script."; exit 1; }

    sudo mkdir -p "$dst"
    sudo cp -r "$src"/* "$dst"/

    # Fonts
    # [[ -d "$dst/Fonts" ]] && sudo cp -r "$dst/Fonts"/* /usr/share/fonts/

    # SDDM config
    sudo tee /etc/sddm.conf >/dev/null <<EOF
[Theme]
Current=$THEME_NAME
EOF

    sudo mkdir -p /etc/sddm.conf.d
    sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null <<EOF
[General]
InputMethod=qtvirtualkeyboard
EOF

    info "Theme installed successfully"
}

# ---------- Choose variant automatically ----------
set_default_variant() {
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=theme.conf|" "$METADATA"
    info "Default theme variant selected: aconfig"
}

# ---------- Enable SDDM ----------
enable_sddm() {
    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    info "SDDM enabled — reboot required"
}

# ---------- MAIN ----------
main() {
    [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }

    echo -e "\e[36m🚀 Starting full SDDM Theme installation (local mode)\e[0m"

    install_deps
    install_theme
    set_default_variant
    enable_sddm

    info "🎉 Installation complete!"
    warn "Please reboot to apply the theme."
}

main
