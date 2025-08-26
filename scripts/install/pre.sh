#!/usr/bin/env bash
# Pre-Installation Script

set -euo pipefail


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
readonly backupSuffix=".aconfig.bkp"
readonly scrDir="$(dirname "$(dirname "$(realpath "$0")")")"
readonly pkgLst="${scrDir}/utils/packages.lst"
readonly installPkgLst="${scrDir}/utils/install_pkg.lst"

source "${scrDir}/global.sh" || { echo "Error: unable to source global.sh"; exit 1; }


# =========================================== #
# ==== PRE-INSTALLATION -> SYSTEM-D BOOT ==== #
# =========================================== #
configure_systemd_boot() {
  if ! pkg_installed systemd || ! nvidia_detect; then return 0; fi

  local product
  product=$(bootctl status 2>/dev/null | awk '$1=="Product:" {print $2}')
  [[ "$product" == "systemd-boot" ]] || return 0

  print_log -sec "bootloader" -stat "Detected" "systemd-boot"

  local conf_files backup_files
  conf_files=$(find /boot/loader/entries/ -name '*.conf' 2>/dev/null | wc -l)
  backup_files=$(find /boot/loader/entries/ -name "*${backupSuffix}" 2>/dev/null | wc -l)

  if [[ $backup_files -eq $conf_files ]]; then
    print_log -y "[bootloader] " -stat "skipped" "systemd-boot already configured"
    return 0
  fi

  print_log -g "[bootloader] " -b " :: " "Adding nvidia_drm.modeset=1 to boot options"

  find /boot/loader/entries/ -name "*.conf" -print0 | while IFS= read -r -d '' conf; do
    sudo cp "$conf" "${conf}${backupSuffix}"
    local options
    options=$(grep -w "^options" "$conf" | sed 's/\b\(quiet\|splash\|nvidia_drm\.modeset=.\)\b//g')
    sudo sed -i "/^options/c${options} quiet splash nvidia_drm.modeset=1" "$conf"
  done
}


# ==================================== #
# ==== PRE-INSTALLATION -> PACMAN ==== #
# ==================================== #
configure_pacman() {
  [[ -f /etc/pacman.conf ]] || return 0

  if [[ -f "/etc/pacman.conf${backupSuffix}" ]]; then
    print_log -sec "PACMAN" -stat "skipped" "Pacman already configured"
    return 0
  fi

  print_log -g "[PACMAN] " -b "Modify :: " "Enhancing pacman configuration"

  sudo cp /etc/pacman.conf "/etc/pacman.conf${backupSuffix}"
  sudo sed -i '
    /^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5
    /^#\[multilib\]/,+1 s/^#//
  ' /etc/pacman.conf

  print_log -g "[PACMAN] " -b "Update :: " "Refreshing packages"
  sudo pacman -Syyu --noconfirm
  sudo pacman -Fy --noconfirm
}


# ====================================================== #
# ==== PRE-INSTALLATION -> Chaotic AUR Installation ==== #
# ====================================================== #
setup_chaotic_aur() {
  if grep -q '\[chaotic-aur\]' /etc/pacman.conf; then
    print_log -sec "CHAOTIC-AUR" -stat "skipped" "Already configured"
    return 0
  fi

  prompt_timer 120 "Install Chaotic AUR? [Y/n/q] "
  case "${PROMPT_INPUT,,}" in
    q|quit) print_log -sec "Chaotic AUR" -crit "Quit" "Exiting"; exit 1 ;;
    n|no)   print_log -sec "Chaotic-aur" -stat "Skipped" "Installation skipped"; return 0 ;;
  esac

  print_log -sec "Chaotic-aur" -stat "Installation" "Installing Chaotic AUR"

  sudo pacman-key --init
  sudo "${scrDir}/chaotic.sh" --install
}


# ======================================================================================== #
# ==== PRE-INSTALLATION -> Prepare Package List with User Packages and NVIDIA Drivers ==== #
# ======================================================================================== #
prepare_packages() {
  local custom_pkg="${1:-}"

  cp "$pkgLst" "$installPkgLst"
  trap "mv '$installPkgLst' '${cacheDir}/logs/${ACONFIG_LOG}/install_pkg.lst'" EXIT

  echo -e "\n#user packages" >> "$installPkgLst"
  [[ -f "$custom_pkg" ]] && cat "$custom_pkg" >> "$installPkgLst"

  # Add NVIDIA packages if detected
  if nvidia_detect; then
    if [[ ${flg_Nvidia:-1} -eq 1 ]]; then
      awk '{print $0"-headers"}' /usr/lib/modules/*/pkgbase >> "$installPkgLst" 2>/dev/null || true
      nvidia_detect --drivers >> "$installPkgLst"
    else
      print_log -warn "Nvidia" "NVIDIA GPU detected but ignored"
    fi
  fi
  nvidia_detect --verbose
}


# =================================================== #
# ==== PRE-INSTALLATION -> Setup Clone Directory ==== #
# =================================================== #
setup_clone_dir() {
  if [[ -d "$cloneDir" ]]; then
    print_log -sec "AUR" -stat "exist" "Clone directory"
    rm -rf "${cloneDir}/${aurHlpr}"
  else
    mkdir -p "$cloneDir"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" > "${cloneDir}/.directory"
    print_log -sec "AUR" -stat "created" "Clone directory"
  fi
}
