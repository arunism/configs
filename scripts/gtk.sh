# GTK Themes & Icons Installation from Repo #
engine=(
    unzip
    gtk-engine-murrine
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Install required engine packages
for pkg in "${engine[@]}"; do
    install_package "$pkg"
done

# Remove existing GTK themes and icons directory
if [ -d "GTK-themes-icons" ]; then
    echo "Removing existing GTK themes/icons directory..."
    rm -rf "GTK-themes-icons"
fi

# Clone and extract GTK themes/icons
echo "Cloning GTK themes and Icons repository..."
if git clone --depth=1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    rm -rf GTK-themes-icons
    echo "GTK Themes & Icons extracted to ~/.icons & ~/.themes"
else
    echo "Error: Failed to download GTK themes and Icons."
fi

printf "\n%.0s" {1..2}

