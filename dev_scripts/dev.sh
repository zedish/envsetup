#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y build-essential pip libusb-dev libusb-1.0-0-dev  
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm lazygit.tar.gz
rm -rf lazygit
# ======= VSCODE Setup ========
./vscode.sh

# ======= Arduino Setup ========
./arduino.sh

# ======= Serial Setup ========
apt install minicom picoterm putty -y
snap install tio --classic


# ======= Language setup ========
# rust
./rust.sh
# ======= Docker setup ========
./docker.sh
