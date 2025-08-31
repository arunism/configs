#!/usr/bin/env bash
# Pre-Installation Script

set -euo pipefail
hyprctl keyword misc:disable_autoreload 1 -q


# ======================================== #
# ==== Import Variables and Functions ==== #
# ======================================== #
readonly scrDir="$(dirname "$(dirname "$(realpath "$0")")")"
readonly fontList="${scrDir}/utils/fonts.lst"
readonly arcDir="${cloneDir}/artificats/archives"

source "${scrDir}/global.sh" || { echo "Error: unable to source global.sh"; exit 1; }


# ================================================== #
# ==== Extract Font archive to Target Directory ==== #
# ================================================== #
extract_font() {
  local font="$1" target="$2"
  local archive="${arcDir}/${font}.tar.gz"

  # Create target directory
  if [[ ! -d "$target" ]]; then
    if ! mkdir -p "$target" 2>/dev/null; then
      print_log -warn "create" "directory as root: $target"
      sudo mkdir -p "$target"
    fi
  fi

  # Extract with appropriate permissions
  if [[ -w "$target" ]]; then
      tar -xzf "$archive" -C "$target/"
  else
    print_log -warn "not writable" "Extracting as root: $target"
    if ! sudo tar -xzf "$archive" -C "$target/" 2>/dev/null; then
      print_log -err "extraction failed" "giving up on $target"
      print_log "Error can be ignored if '$target' is not writable"
      return 1
    fi
  fi

  print_log "${font}.tar.gz" -r " --> " "${target}"
}


# ============================================= #
# ==== Process Font List and Extract Fonts ==== #
# ============================================= #
process_fonts() {
  local font target

  while IFS='|' read -r font target; do
    # Skip comments and malformed lines
    [[ "$font" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$font" || -z "$target" ]] && continue

    # Expand variables in target path
    target=$(eval "echo $target")

    extract_font "$font" "$target"

  done < <(grep -v '^[[:space:]]*#' "$fontList" | grep -E '.+\|.+')

  echo
  print_log -stat "rebuild" "font cache"
  fc-cache -f
}
