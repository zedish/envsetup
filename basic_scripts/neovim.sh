#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

apt install -y libfuse2 git unzip make gcc xclip ripgrep
wget https://github.com/neovim/neovim/releases/download/v0.10.1/nvim.appimage
mv nvim.appimage /usr/local/bin/nvim
chmod 755 /usr/local/bin/nvim
rm -rf /home/$SUDO_USER/.config/nvim
git clone https://github.com/zedish/kickstart.nvim.git /home/$SUDO_USER/.config/nvim
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/nvim
grep -qxF 'alias vim="nvim"' /home/$SUDO_USER/.bashrc || echo 'alias vim="nvim"' >> /home/$SUDO_USER/.bashrc

apt install nodejs npm python3-neovim -y

