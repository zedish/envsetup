#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# ======= Signal Setup ========
if ! command -v signal-desktop >&2; then
#  wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
#  cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
#  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#    sudo tee /etc/apt/sources.list.d/signal-xenial.list
#  sudo apt update && sudo apt install -y signal-desktop
#  rm signal-desktop-keyring.gpg
  snap install signal-desktop
else
  echo "signal already installed"
fi

# ======= Discord Setup ========
sudo snap install discord


# ======= OBS Setup ========
add-apt-repository ppa:obsproject/obs-studio -y
apt update -y
apt install ffmpeg obs-studio -y
