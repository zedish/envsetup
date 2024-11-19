#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if ! command -v kismet >&2; then
  wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key --quiet | gpg --dearmor | sudo tee /usr/share/keyrings/kismet-archive-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/noble noble main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  sudo apt update
  #sudo apt install kismet -y
  DEBIAN_FRONTEND=noninteractive apt-get -y install kismet > /dev/null
  sudo usermod -aG kismet $SUDO_USER
else
  echo "kismet already installed"
fi

