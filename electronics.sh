#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
if ! command -v kicad >&2; then
  sudo add-apt-repository --yes ppa:kicad/kicad-8.0-releases
  sudo apt update
  sudo apt install --install-recommends kicad -y
else
  echo "KiCAD already installed"
fi

