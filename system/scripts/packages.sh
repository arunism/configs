#!/bin/bash

# System Update
apt update

# Function to install python3-pip
install_pip() {
  echo "Installing python3-pip..."
  apt install -y python3-pip

  echo "Python3-pip installation completed!"
}

# Function to install python3-venv
install_venv() {
  echo "Installing python3-venv..."
  apt install -y python3-venv

  echo "Python3-venv installation completed!"
}

# Function to install python-poetry
install_poetry() {
  echo "Installing python-poetry..."
  curl -sSL https://install.python-poetry.org | python3 -
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  poetry config virtualenvs.in-project true

  echo "Poetry installation completed!"
}

# Function to install pyenv
install_pyenv() {
  echo "Installing pyenv..."
  
  apt-get install libssl-dev
  curl https://pyenv.run | bash
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

  echo "Pyenv installation completed!"
}

# Function to install neovim
install_neovim() {
  echo "Installing neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  rm -rf /opt/nvim
  tar -C /opt -xzf nvim-linux64.tar.gz
  echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc

  echo "NeoVim installation completed!"
}

# Function to install nodejs along with npm
install_nodejs() {
  echo "Installing nodejs along with npm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"

  nvm install 20

  echo "Nodejs installation completed!"
}

# Install xclip: A clipboard for Neovim
install_xclip() {
  echo "Installing xclip..."
  apt install -y xclip

  echo "xClip installation completed!"
}


install_ripgrip() {
  echo "Installing ripgrep..."
  apt-get install ripgrep

  echo "ripgrep installation completed!"
}


install_docker() {
  echo "Installing Docker..."

  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

  # Add Docker's official GPG key:
  apt-get update
  apt-get install ca-certificates curl
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  
  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update

  apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Install Postman
install_postman() {
  echo "Installing Postman..."

  POSTMAN_URL="https://dl.pstmn.io/download/latest/linux64"
  INSTALL_DIR="/opt/postman"
  TEMP_ARCHIVE="/tmp/postman.tar.gz"

  # Download the latest version of Postman using curl
  echo "Downloading Postman..."
  curl -L -o "$TEMP_ARCHIVE" "$POSTMAN_URL"

  # Extract Postman archive
  echo "Extracting Postman archive..."
  mkdir -p "$INSTALL_DIR"
  tar -xzf "$TEMP_ARCHIVE" -C "$INSTALL_DIR"

  # Create symlink
  ln -sf "$INSTALL_DIR/Postman/Postman" /usr/bin/postman

  # Create desktop entry
  echo "[Desktop Entry]
  Encoding=UTF-8
  Name=Postman
  Exec=$INSTALL_DIR/Postman/app/Postman %U
  Icon=$INSTALL_DIR/Postman/app/resources/app/assets/icon.png
  Terminal=false
  Type=Application
  Categories=Development;" > ~/.local/share/applications/Postman.desktop

  echo "Postman installation completed!"
}


# Install Obsidian
install_obsidian() {
  echo "Installing Obsidian..."

  latest_release=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest)
  download_url=$(echo "$latest_release" | grep browser_download_url | grep amd64.deb | cut -d '"' -f 4)
  version_name=$(echo "$latest_release" | grep tag_name | cut -d '"' -f 4)
  wget "$download_url" -O "obsidian-${version_name}-amd64.deb"
  dpkg -i "obsidian-${version_name}-amd64.deb"
  rm "obsidian-${version_name}-amd64.deb"
  
  echo "Obsidian ${version_name} has been installed successfully."
}


# List of all the packages
packages=(
  "python3-pip,install_pip"
  "python3-venv,install_venv"
  "python-poetry,install_poetry"
  "pyenv,install_pyenv"
  "neovim,install_neovim"
  "nodejs,install_nodejs"
  "xclip,install_xclip"
  "ripgrip,install_ripgrip"
  "postman, install_postman"
  "obsidian, install_obsidian"
)

# Ask user if they want to install all packages
read -p "Do you want to install all packages (python3-pip, python3-venv, python-poetry)? [y/N]: " install_all

if [[ "$install_all" =~ ^[Yy]$ ]]; then
  # Install all packages together
  for package in "${packages[@]}"; do
    IFS=',' read -r package_name install_function <<< "$package"
    "$install_function"
  done
else
  # Ask individually for each package
  for package in "${packages[@]}"; do
    IFS=',' read -r package_name install_function <<< "$package"
      read -p "Do you want to install $package_name? [y/N]: " install_input
      if [[ "$install_input" =~ ^[Yy]$ ]]; then
        "$install_function"
      fi
  done
fi

echo "Installation complete."

