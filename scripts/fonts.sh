# List of required fonts
fonts=(
  adobe-source-code-pro-fonts
  noto-fonts-emoji
  otf-font-awesome
  ttf-droid
  ttf-fira-code
  ttf-fantasque-nerd
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  ttf-victor-mono
  noto-fonts
)

# Source global functions from an external script
source "$(dirname "$(readlink -f "$0")")/scripts/global.sh"

# Installing fonts
echo -e "\n${NOTE} Installing fonts..."

for PKG in "${fonts[@]}"; do
  install_package "$PKG"
done

echo "\n${OK} Font installation complete."


# Print two blank lines for readability
printf "\n%.0s" {1..2}

