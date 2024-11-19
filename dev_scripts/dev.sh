#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y build-essential pip libusb-dev libusb-1.0-0-dev  

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
