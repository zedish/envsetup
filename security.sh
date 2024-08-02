#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y nmap gnuradio gqrx-sdr 

echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark > /dev/null
apt install -y tshark

