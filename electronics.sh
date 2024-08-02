#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y kicad 
