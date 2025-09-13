#!/usr/bin/env bash
# Main Installation Script

set -euo pipefail


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
readonly backupSuffix=".aconfig.bkp"
readonly aConfigPath="$HOME/.local/lib/aconfig"
readonly scrDir="$(dirname "$(realpath "$0")")"
readonly installPkgLst="${scrDir}/install_pkg.lst"

source "${scrDir}/global.sh" || { echo "Error: unable to source global.sh"; exit 1; }
source "${scrDir}/install/pre.sh" || { echo "Error: unable to source install/pre.sh"; exit 1; }
source "${scrDir}/install/main.sh" || { echo "Error: unable to source install/main.sh"; exit 1; }
source "${scrDir}/install/post.sh" || { echo "Error: unable to source install/post.sh"; exit 1; }
source "${scrDir}/restore/fonts.sh" || { echo "Error: unable to source restore/fonts.sh"; exit 1; }


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
  process_and_install_packages
  process_fonts
}

main "$@"
