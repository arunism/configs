# Hyprland Configurations

## Installation

Installation can be done using default package manager: `pacman` and other supporting package managers like `yay`.

Install `pacman` packages using following command:

```shell
sudo pacman -S \
    python-pip \
    nodejs \
    npm \
    xclip \
    vlc \
    vlc-plugin-ffmpeg \
    nsxiv \
    waybar \
    rofi \
    yazi \
    ttf-font-awesome \
    pipewire pipewire-pulse wireplumber \
```

Now other package managers like `yay` do not come pre-installed with the arch linux and should be installed separately. This can be done as below:

```shell
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ..
rm -rf yay/
```

Now install `yay` packages following the similar command as below:

```shell
sudo yay -S \
    yaak \
    google-chrome \
    stremio \
    hyprshot \
    hyprlock \
    hypridle \
    hyprpaper \
    nwg-look \
    wlogout \
    mongodb-compass \
    catppuccin-gtk-theme-mocha \
```
