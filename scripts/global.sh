set -e

# Set color codes for output
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Install a package with pacman
install_package_pacman() {
  if pacman -Q "$1" &>/dev/null ; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} already installed."
  else
    # Install package and log output
    stdbuf -oL sudo pacman -S --noconfirm "$1" 2>&1 >> "$LOG" 

    # Verify installation
    if pacman -Q "$1" &>/dev/null ; then
      echo -e "${OK} ${YELLOW}$1${RESET} installed."
    else
      echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed. Check $LOG."
    fi
  fi
}

# Determine AUR helper (yay or paru)
ISAUR=$(command -v yay || command -v paru)

# Install a package using AUR helper (yay/paru)
install_package() {
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} already installed."
  else
    # Install package and log output
    stdbuf -oL $ISAUR -S --noconfirm "$1" 2>&1 >> "$LOG" 

    # Verify installation
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e "${OK} ${YELLOW}$1${RESET} installed."
    else
      echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed. Check install.log."
    fi
  fi
}

# Install a package without checking if it's already installed
install_package_f() {
  stdbuf -oL $ISAUR -S --noconfirm "$1" 2>&1 >> "$LOG" 

  # Verify installation
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e "${OK} ${YELLOW}$1${RESET} installed."
  else
    echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed. Check install.log."
  fi
}

# Uninstall a package
uninstall_package() {
  local pkg="$1"

  if pacman -Qi "$pkg" &>/dev/null; then
    echo -e "${NOTE} Removing $pkg..."
    sudo pacman -R --noconfirm "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"
    
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo -e "\e[1A\e[K${OK} $pkg removed."
    else
      echo -e "\e[1A\e[K${ERROR} $pkg removal failed."
      return 1
    fi
  else
    echo -e "${INFO} $pkg not installed, skipping."
  fi
  return 0
}
