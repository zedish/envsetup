#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if ! command -v urh >&2; then
    pipx install urh
    pipx ensurepath
    cd $WDIR
    sudo cp 10-rtl-sdr.rules /etc/udev/rules.d
else
    echo "urh already installed"
fi

