#!/usr/bin/env bash
# Main Installation Script

set -euo pipefail


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
readonly backupSuffix=".aconfig.bkp"
readonly aConfigPath="$HOME/.local/lib/aconfig"
readonly scrDir="$(dirname "$(realpath "$0")")"
readonly pkgLst="${scrDir}/packages.lst"
readonly installPkgLst="${scrDir}/install_pkg.lst"

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


# ==================================================================== #
# ==== Prepare Package List with User Packages and NVIDIA Drivers ==== #
# ==================================================================== #
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


# =============================== #
# ==== Setup Clone Directory ==== #
# =============================== #
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


# ============================ #
# ==== Install AUR Helper ==== #
# ============================ #
install_aur_helper() {
  # Check if AUR helper already installed
  if chk_list "aurHlpr" "${aurList[@]}"; then
    print_log -sec "AUR" -stat "Detected" "${aurHlpr}"
    exit 0
  fi

  # Ensure git is available
  pkg_installed git || { print_log -sec "AUR" -crit "git dependency missing"; exit 1; }

  local repo_url="https://aur.archlinux.org/${aurHlpr}.git"
  local target_dir="${cloneDir}/${aurHlpr}"

  git clone "$repo_url" "$target_dir"

  if (cd "$target_dir" && makepkg "${use_default:-}" -si); then
    print_log -sec "AUR" -stat "installed" "${aurHlpr} AUR helper"
  else
    print_log -r "AUR" -crit "failed" "${aurHlpr} installation failed"
    exit 1
  fi
}


# ==================================== #
# ==== Check Package Dependencies ==== #
# ==================================== #
check_dependencies() {
  local deps="$1" pkg="$2"
  [[ -z "$deps" ]] && return 0

  local dep
  while read -r dep; do
    [[ -z "$dep" ]] && continue

    # Check if dependency is in package list or already installed
    if ! grep -q "^${dep}|" "$PKG_LIST" && ! pkg_installed "$dep"; then
      print_log -warn "missing" "dependency [$dep] for $pkg"
      return 1
    fi
  done <<< "${deps//|/$'\n'}"
  return 0
}


# ============================================== #
# ==== Process Packages and Categorize Them ==== #
# ============================================== #
process_packages() {
  local pkg deps repo

  while IFS='|' read -r pkg deps; do
    pkg="${pkg// /}"
    [[ -z "$pkg" ]] && continue

    # Skip if dependencies not met
    if ! check_dependencies "$deps" "$pkg"; then
      continue
    fi

    # Categorize package
    if pkg_installed "$pkg"; then
      print_log -y "[skip] " "$pkg"
    elif pkg_available "$pkg"; then
      repo=$(pacman -Si "$pkg" 2>/dev/null | awk '/^Repository/ {print $3}' || echo "unknown")
      print_log -b "[queue] " "$pkg" -b " :: " -g "$repo"
      arch_packages+=("$pkg")
    elif aur_available "$pkg"; then
      print_log -b "[queue] " "$pkg" -b " :: " -g "aur"
      aur_packages+=("$pkg")
    else
      print_log -r "[error] " "unknown package $pkg"
    fi
  done < <(sed 's/#.*//' "$PKG_LIST")
}


# ================================== #
# ==== Install Packages by Type ==== #
# ================================== #
install_packages() {
  local -n packages=$1
  local type="$2" cmd="$3"

  (( ${#packages[@]} == 0 )) && return 0

  print_log -b "[install] " "$type packages"

  if [[ ${flg_DryRun:-0} -eq 1 ]]; then
    printf '[pkg] %s\n' "${packages[@]}"
  else
    $cmd ${use_default:+"$use_default"} -S "${packages[@]}"
  fi
}


# Restore configurations and generate cache
restore_and_cache() {
  "${scrDir}"/restore_{fnt,cfg,thm}.sh

  print_log -g "[generate] " "cache ::" "Wallpapers"

  if [[ ${flg_DryRun:-0} -ne 1 ]]; then
    export PATH="${aConfigPath}:$HOME/.local/bin:${PATH}"
    "${aConfigPath}/swwwallcache.sh" -t ""
    "${aConfigPath}/theme.switch.sh" -q || true
    "${aConfigPath}/waybar.py" --update || true
    echo "[install] reload :: Hyprland"
  fi
}


# ======================== #
# ==== Main Execution ==== #
# ======================== #
main() {
  configure_systemd_boot
  configure_pacman
  setup_chaotic_aur
  prepare_packages
  setup_clone_dir
  install_aur_helper
  process_packages

  echo
  install_packages arch_packages "arch" "sudo pacman"
  echo
  install_packages aur_packages "aur" "$aurHlpr"
}

main "$@"
