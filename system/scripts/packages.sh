#!/bin/bash

# System Update
apt update

# Function to install python3-pip
install_pip() {
    echo "Installing python3-pip..."
    apt install -y python3-pip
}

# Function to install python3-venv
install_venv() {
    echo "Installing python3-venv..."
    apt install -y python3-venv
}

# Function to install python-poetry
install_poetry() {
    echo "Installing python-poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    poetry config virtualenvs.in-project true
}

# Function to install neovim
install_neovim() {
    echo "Installing neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    rm -rf /opt/nvim
    tar -C /opt -xzf nvim-linux64.tar.gz
    echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
}

# Install xclip: A clipboard for Neovim
install_xclip() {
    echo "Installing xclip..."
    apt install -y xclip
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
  sudo mkdir -p "$INSTALL_DIR"
  sudo tar -xzf "$TEMP_ARCHIVE" -C "$INSTALL_DIR"

  # Create symlink
  sudo ln -sf "$INSTALL_DIR/Postman/Postman" /usr/bin/postman

  # Create desktop entry
  echo "[Desktop Entry]
  Version=1.0
  Name=Postman
  Exec=postman
  Icon=$INSTALL_DIR/Postman/app/resources/app/assets/icon.png
  Terminal=false
  Type=Application
  Categories=Development;" > ~/.local/share/applications/postman.desktop

  echo "Postman installation completed!"
}




# List of all the packages
packages=(
    "python3-pip,install_pip"
    "python3-venv,install_venv"
    "python-poetry,install_poetry"
    "neovim,install_neovim"
    "xclip,install_xclip"
    "postman, install_postman"
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

