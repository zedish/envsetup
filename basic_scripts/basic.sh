#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

# ======= Get updates ========
apt-get update
apt-get upgrade -y

# ======= Required things ========
sudo su -c "settings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
sudo su -c "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"

# ======= Tools for fetching and building from source ========
apt install build-essential cmake git pkg-config gcc make -y
apt install libusb-dev libusb-1.0-0-dev -y

# ======= Neovim Setup ========
./neovim.sh

# ======= Media Setup ========
apt install imagemagick-6.q16 webp gimp ffmpeg vlc -y

# ======= Filesystem Setup ========
apt install 7zip libfuse2 ncdu -y
apt install caffeine gnome-tweaks neofetch -y
apt install htop typecatcher -y
apt install thefuck -y
apt install sl cowsay -y
apt install curl -y
apt install python3-pip pipx -y

# ======= Pipx autocomplete Setup ========
if ! grep 'eval "$(register-python-argcomplete pipx)"' /home/$SUDO_USER/.bashrc >&2; then
  echo 'eval "$(register-python-argcomplete pipx)"' >> /home/$SUDO_USER/.bashrc
fi

# ======= Auto start ssh agent ========
if ! grep 'eval "$(ssh-agent -s)"' /home/$SUDO_USER/.bashrc >&2; then
  echo 'eval "$(ssh-agent -s)"' >> /home/$SUDO_USER/.bashrc
fi

mkdir -p /home/$SUDO_USER/.local/share/icons

# ======= Obsidian Setup ========
./obsidian.sh
