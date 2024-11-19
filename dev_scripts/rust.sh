#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if command -v rustup >&2; then
  echo "rustup already installed"
else
  su $SUDO_USER -c "curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -ssf | sh -s -- -y"
  sed -i '/-- rust_analyzer/s/-- //' /home/$SUDO_USER/.config/nvim/init.lua

fi
cargo install cargo-watch

