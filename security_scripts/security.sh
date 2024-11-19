#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

secDir = "/home/$SUDO_USER/Sec_Tools"
export secDir
mkdir $secDir

# =======  Setup ========
apt install -y gnuradio gqrx-sdr 
#apt install -y nmap
sudo snap install nmap
sudo snap connect nmap:network-control

# ======= Wireshark Setup ========
./wireshark.sh

# ======= RTL-SDR Setup ========
./rtl_sdr.sh

# ======= Kismet Setup ========
./kismet.sh

# ======= Universal Radio Hacker Setup ========
./universal_radio.sh

# ======= Flipper Setup ========
./flipper.sh
