#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

sed -i '/-- gopls/s/-- //' /home/$SUDO_USER/.config/nvim/init.lua
wget https://go.dev/dl/go1.23.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz
echo "after tar"
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/$SUDO_USER/.bashrc
echo "afer bashrc"
rm go1.23.3.linux-amd64.tar.gz
echo "after rm"
