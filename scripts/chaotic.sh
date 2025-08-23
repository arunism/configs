#!/usr/bin/env bash

# Optimized Chaotic AUR installer
set -euo pipefail

CHAOTIC_KEY="3056513887B78AEB"
CHAOTIC_FULL_KEY="EF925EA60F33D0CB85C44AD13056513887B78AEB"
KEYRING_URL="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
MIRRORLIST_URL="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"

msg() { echo -e "\033[33m━━ $1 ━━\033[0m"; }
error() { echo -e "\033[31mError: $1\033[0m" >&2; exit 1; }

check_root() { [[ $EUID -eq 0 ]] || error "Must run as root"; }
check_internet() { ping -q -c1 -W1 8.8.8.8 &>/dev/null || error "No internet"; }
check_arch() { command -v pacman &>/dev/null || error "Not Arch Linux"; }

is_installed() { grep -q "chaotic-aur" /etc/pacman.conf 2>/dev/null; }

install() {
  msg "Installing Chaotic AUR"
  pacman-key --recv-key $CHAOTIC_KEY --keyserver keyserver.ubuntu.com
  pacman-key --lsign-key $CHAOTIC_KEY
  pacman -U --noconfirm "$KEYRING_URL" "$MIRRORLIST_URL"
  echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
  pacman -Sy
  msg "Chaotic AUR installed successfully"
}

purge() {
  msg "Removing Chaotic AUR"
  pacman-key --delete $CHAOTIC_FULL_KEY 2>/dev/null || true
  pacman -Rns --noconfirm chaotic-{keyring,mirrorlist} 2>/dev/null || true
  sed -i '/chaotic-aur\|chaotic-mirrorlist/d' /etc/pacman.conf
  pacman -Sy
  msg "Chaotic AUR removed successfully"
}

case "${1:-}" in
  --install)
    check_arch; check_root; check_internet
    is_installed && { echo "Already installed. Reinstall? [y/N]"; read -r ans; [[ $ans =~ ^[Yy]$ ]] || exit 0; }
    install ;;
  --uninstall)
    check_arch; check_root
    purge ;;
  *)
    cat << EOF
Usage: $0 [option]
  --install    Install Chaotic AUR
  --uninstall  Remove Chaotic AUR
EOF
    ;;
esac
