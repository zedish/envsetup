#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# ======= Signal Setup ========
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop
rm signal-desktop-keyring.gpg

# ======= Discord Setup ========
wget   https://dl.discordapp.net/apps/linux/0.0.62/discord-0.0.62.deb
apt install ./discord-0.0.62.deb
rm discord-0.0.62.deb
