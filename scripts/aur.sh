# Function to install an AUR helper
install_aur_helper() {
    local helper_name=$1
    local repo_url=$2

    echo "Installing $helper_name..."

    # Install dependencies
    sudo pacman -S --noconfirm base-devel git

    # Clone the repository
    git clone "$repo_url" "$helper_name"
    cd "$helper_name"

    # Build and install the AUR helper
    makepkg -si --noconfirm
    cd ..
    rm -rf "$helper_name"

    echo "$helper_name has been installed!"
}

# Main script
echo "Which AUR helper would you like to install?"
echo "1. yay"
echo "2. paru"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        install_aur_helper "yay" "https://aur.archlinux.org/yay.git"
        ;;
    2)
        install_aur_helper "paru" "https://aur.archlinux.org/paru.git"
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1 or 2."
        exit 1
        ;;
esac
