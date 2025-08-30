#!/usr/bin/env bash
# Main Installation Script

set -euo pipefail


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
readonly scrDir="$(dirname "$(dirname "$(realpath "$0")")")"
readonly pkgLst="${scrDir}/utils/packages.lst"

source "${scrDir}/global.sh" || { echo "Error: unable to source global.sh"; exit 1; }

export arch_packages=()
export aur_packages=()


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
    cd .. && sudo rm -rf "$target_dir"
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
    if ! grep -q "^${dep}|" "$pkgLst" && ! pkg_installed "$dep"; then
      print_log -warn "missing" "dependency [$dep] for $pkg"
      return 1
    fi
  done <<< "${deps//|/$'\n'}"
  return 0
}


# ======================================================== #
# ==== Process Packages, Categorize, and Install them ==== #
# ======================================================== #
process_and_install_packages() {
  # STEP 1: Process Packages
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
  done < <(sed 's/#.*//' "$pkgLst")

  install_packages arch_packages "arch" "sudo pacman"
  install_packages aur_packages "aur" "$aurHlpr"
}


# ================================== #
# ==== Install Packages by Type ==== #
# ================================== #
install_packages() {
  local -n packages=$1
  local pkgType="$2" cmd="$3"

  (( ${#packages[@]} == 0 )) && return 0

  print_log -b "[install] " "$pkgType packages"

  $cmd ${use_default:+"$use_default"} -S "${packages[@]}"
}
