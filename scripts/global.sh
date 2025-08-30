#!/usr/bin/env bash


set -euo pipefail

# Directory and cache setup
readonly SCRIPT_DIR="$(dirname "$(realpath "$0")")"
readonly CLONE_DIR="${CLONE_DIR:-$(dirname "$SCRIPT_DIR")}"
readonly CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/aconfig"

export cloneDir="$CLONE_DIR" confDir="$CONF_DIR" cacheDir="$CACHE_DIR"
export aurHlpr="yay" myShell="zsh" ACONFIG_LOG="$(date +'%y%m%d_%Hh%Mm%Ss')"


# ============================ #
# ==== Package Management ==== #
# ============================ #
pkg_installed() { pacman -Q "$1" &>/dev/null; }
pkg_available() { pacman -Si "$1" &>/dev/null; }
aur_available() { yay -Si "$1" &>/dev/null; }

chk_list() {
  local var_name="$1" && shift
  for pkg in "$@"; do
    if pkg_installed "$pkg"; then
      printf -v "$var_name" "%s" "$pkg"
      export "$var_name"
      return 0
    fi
  done
  return 1
}


# ======================= #
# ==== GPU Detection ==== #
# ======================= #
nvidia_detect() {
  local gpus=($(lspci -k | awk -F': ' '/VGA|3D/{print $NF}'))
  case "${1:-}" in
    --verbose) printf "\033[0;32m[gpu%s]\033[0m detected :: %s\n" "$@" "${dGPU[@]}" ;;
    --drivers)
      for gpu in "${gpus[@]}"; do
        [[ "$gpu" =~ NVIDIA ]] && echo -e "nvidia\nnvidia-utils" && break
      done ;;
    *) [[ "${gpus[*]}" =~ NVIDIA ]] ;;
  esac
}


# ================================= #
# ==== User Input with Timeout ==== #
# ================================= #
prompt_timer() {
    set +e; unset PROMPT_INPUT
    local sec=$1 msg="$2"
    while ((sec >= 0)); do
        printf '\r :: %s (%ds) : ' "$msg" "$sec"
        read -rt 1 -n 1 PROMPT_INPUT && break
        ((sec--))
    done
    export PROMPT_INPUT; echo; set -e
}


# ========================== #
# ==== Logging Function ==== #
# ========================== #
print_log() {
  local log_file="${CACHE_DIR}/logs/${ACONFIG_LOG}/${0##*/}"
  [[ -n "${ACONFIG_LOG:-}" ]] && mkdir -p "$(dirname "$log_file")"

  {
    [[ -n "${log_section:-}" ]] && printf '\033[32m[%s]\033[0m ' "$log_section"
    while (($#)); do
      case "$1" in
        -r) printf '\033[31m%s\033[0m' "$2"; shift 2 ;;
        -g) printf '\033[32m%s\033[0m' "$2"; shift 2 ;;
        -y) printf '\033[33m%s\033[0m' "$2"; shift 2 ;;
        -b) printf '\033[34m%s\033[0m' "$2"; shift 2 ;;
        -m) printf '\033[35m%s\033[0m' "$2"; shift 2 ;;
        -c) printf '\033[36m%s\033[0m' "$2"; shift 2 ;;
        -n) printf '\033[96m%s\033[0m' "$2"; shift 2 ;;
        -stat) printf '\033[30;46m %s \033[0m :: ' "$2"; shift 2 ;;
        -crit) printf '\033[97;41m %s \033[0m :: ' "$2"; shift 2 ;;
        -warn) printf 'WARNING :: \033[30;43m %s \033[0m :: ' "$2"; shift 2 ;;
        -sec) printf '\033[32m[%s]\033[0m ' "$2"; shift 2 ;;
        -err) printf 'ERROR :: \033[4;31m%s\033[0m ' "$2"; shift 2 ;;
        *) printf '%s' "$1"; shift ;;
      esac
    done
    echo
  } | if [[ -n "${ACONFIG_LOG:-}" ]]; then
    tee >(sed 's/\x1b\[[0-9;]*m//g' >> "$log_file")
  else
    cat
  fi
}
