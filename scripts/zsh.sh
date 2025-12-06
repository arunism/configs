# Zsh packages
zsh_pkg=(
  lsd
  mercurial
  zsh
  zsh-completions
  fzf  # Additional Package
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install core Zsh packages
echo "Installing core Zsh packages..."
for pkg in "${zsh_pkg[@]}"; do
  install_package "$pkg"
done

# Remove existing zsh-completions directory if it exists
[ -d "zsh-completions" ] && rm -rf zsh-completions

# Install Oh My Zsh if not already installed
if command -v zsh >/dev/null; then
  echo "Installing Oh My Zsh and plugins..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then  
    sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended
  else
    echo "Oh My Zsh already installed. Skipping."
  fi
  
  # Install plugins if not already installed
  [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  
  # Backup and copy new Zsh config files
  [ -f "$HOME/.zshrc" ] && cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup"
  [ -f "$HOME/.zprofile" ] && cp -b "$HOME/.zprofile" "$HOME/.zprofile-backup"
  cp -r '.zshrc' ~/

  # Set default shell to zsh if not already set
  current_shell=$(basename "$SHELL")
  if [ "$current_shell" != "zsh" ]; then
    echo "Changing default shell to Zsh..."
    while ! chsh -s "$(command -v zsh)"; do
      echo "Authentication failed. Please enter the correct password."
      sleep 1
    done
    echo "Shell changed successfully to Zsh."
  else
    echo "Your shell is already Zsh."
  fi
fi


echo "${OK} Zsh setup complete!"

# Print two blank lines for readability
printf "\n%.0s" {1..2}

