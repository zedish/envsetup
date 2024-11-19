#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if ! command -v wireshark >&2; then
  sudo add-apt-repository ppa:wireshark-dev/stable -y
  sudo apt update
  DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark > /dev/null
  apt install -y tshark
  sudo usermod -a -G wireshark "$SUDO_USER"
fi

