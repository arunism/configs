#!/usr/bin/env bash
# Main Installation Script


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
scrDir="$(dirname "$(realpath "$0")")"
if ! source "${scrDir}/global.sh"; then
  echo "Error: unable to source global.sh..."
  exit 1
fi


# =========================================== #
# ==== PRE-INSTALLATION -> SYSTEM-D BOOT ==== #
# =========================================== #
if pkg_installed systemd && nvidia_detect && [ "$(bootctl status 2>/dev/null | awk '{if ($1 == "Product:") print $2}')" == "systemd-boot" ]; then
  print_log -sec "bootloader" -stat "Detected" "systemd-boot"

  if [ "$(find /boot/loader/entries/ -type f -name '*.conf.aconfig.bkp' 2>/dev/null | wc -l)" -ne "$(find /boot/loader/entries/ -type f -name '*.conf' 2>/dev/null | wc -l)" ]; then
    print_log -g "[bootloader] " -b " :: " "NVIDIA detected! Adding nvidia_drm.modeset=1 to boot option..."
    find /boot/loader/entries/ -type f -name "*.conf" | while read -r imgconf; do
      sudo cp "${imgconf}" "${imgconf}.aconfig.bkp"
      sdopt=$(grep -w "^options" "${imgconf}" | sed 's/\b quiet\b//g' | sed 's/\b splash\b//g' | sed 's/\b nvidia_drm.modeset=.\b//g')
      sudo sed -i "/^options/c${sdopt} quiet splash nvidia_drm.modeset=1" "${imgconf}"
    done
  else
    print_log -y "[bootloader] " -stat "skipped" "systemd-boot is already configured..."
  fi
fi


# ==================================== #
# ==== PRE-INSTALLATION -> PACMAN ==== #
# ==================================== #
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.aconfig.bkp ]; then
  print_log -g "[PACMAN] " -b "Modify :: " "Adding extra spice to pacman..."

  # shellcheck disable=SC2154
  sudo cp /etc/pacman.conf /etc/pacman.conf.aconfig.bkp
  sudo sed -i "/^#Color/c\Color\nILoveCandy
  /^#VerbosePkgLists/c\VerbosePkgLists
  /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
  sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

  print_log -g "[PACMAN] " -b "Update :: " "Packages..."
  sudo pacman -Syyu
  sudo pacman -Fy
else
  print_log -sec "PACMAN" -stat "skipped" "Pacman is already configured..."
fi

if grep -q '\[chaotic-aur\]' /etc/pacman.conf; then
  print_log -sec "CHAOTIC-AUR" -stat "skipped" "Chaotic AUR entry found in pacman.conf..."
else
  prompt_timer 120 "Would you like to install Chaotic AUR? [y/n] | q to quit "
  is_chaotic_aur=false
    case "${PROMPT_INPUT}" in
      y | Y) is_chaotic_aur=true ;;
      n | N) is_chaotic_aur=false ;;
      q | Q)
        print_log -sec "Chaotic AUR" -crit "Quit" "Exiting..."
        exit 1 ;;
      *) is_chaotic_aur=true ;;
    esac
    if [ "${is_chaotic_aur}" == true ]; then
      print_log -sec "Chaotic-aur" -stat "Installation" "Installing Chaotic AUR..."
      if [[ "${flg_DryRun}" -ne 1 ]]; then
        sudo pacman-key --init
        sudo "${scrDir}/chaotic.sh" --install
      fi
    else
      print_log -sec "Chaotic-aur" -stat "Skipped" "Chaotic AUR Installation Skipped..."
    fi
fi
