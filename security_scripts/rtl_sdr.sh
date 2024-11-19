#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

cd $secDir
if ! command -v rtl_sdr >&2; then
  if ! [ -d librtlsdr ]; then
    git clone https://github.com/librtlsdr/librtlsdr.git
    cd librtlsdr
    git status
    git checkout master
    mkdir build && cd build
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
    make
    sudo make install
    sudo ldconfig
  fi
else
  echo "rtl_sdr already installed"
fi

