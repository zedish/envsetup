#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# ======= Signal Setup ========
if ! command -v signal-desktop >&2; then
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
