#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

# ======= Get updates ========
apt-get update
apt-get upgrade -y

# ======= Required things ========
sudo su -c "settings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
sudo su -c "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"

# ======= Tools for fetching and building from source ========
apt install build-essential cmake git pkg-config gcc make -y
apt install libusb-dev libusb-1.0-0-dev -y

# ======= Neovim Setup ========
apt install -y libfuse2 git unzip make gcc xclip ripgrep
wget https://github.com/neovim/neovim/releases/download/v0.10.1/nvim.appimage
mv nvim.appimage /usr/local/bin/nvim
chmod 755 /usr/local/bin/nvim
rm -rf /home/$SUDO_USER/.config/nvim
git clone https://github.com/zedish/kickstart.nvim.git /home/$SUDO_USER/.config/nvim
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/nvim
grep -qxF 'alias vim="nvim"' /home/$SUDO_USER/.bashrc || echo 'alias vim="nvim"' >> /home/$SUDO_USER/.bashrc

apt install nodejs npm python3-neovim -y


# ======= Media Setup ========
apt install imagemagick-6.q16 webp gimp ffmpeg vlc -y

# ======= Filesystem Setup ========
apt install 7zip libfuse2 ncdu -y
apt install caffeine gnome-tweaks neofetch -y
apt install htop typecatcher -y
apt install thefuck -y
apt install sl cowsay -y
apt install curl -y
apt install python3-pip pipx -y

# ======= Pipx autocomplete Setup ========
if ! grep 'eval "$(register-python-argcomplete pipx)"' /home/$SUDO_USER/.bashrc >&2; then
  echo 'eval "$(register-python-argcomplete pipx)"' >> /home/$SUDO_USER/.bashrc
fi




mkdir -p /home/$SUDO_USER/.local/share/icons



# ======= Obsidian Setup ========
if ! [ -f /home/$SUDO_USER/.local/share/applications/obsidian.desktop ]; then
  cd /home/$SUDO_USER/.local/bin
  wget -nc -P /home/$SUDO_USER/.local/bin https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/Obsidian-1.6.7.AppImage
  chmod u+x /home/$SUDO_USER/.local/bin/Obsidian-1.6.7.AppImage
  chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/bin/Obsidian-1.6.7.AppImage
  /home/$SUDO_USER/.local/bin/Obsidian-1.6.7.AppImage --appimage-extract
  mv squashfs-root/usr/share/icons/hicolor/512x512/apps/obsidian.png /home/$SUDO_USER/.local/share/icons
  rm -rf squashfs-root
  echo "
[Desktop Entry]
Name=Obsidian
Exec=/home/$SUDO_USER/.local/bin/Obsidian-1.6.7.AppImage --no-sandbox %U
Terminal=false
Type=Application
Icon=/home/$SUDO_USER/.local/share/icons/obsidian.png
StartupWMClass=obsidian
X-AppImage-Version=1.6.7
Comment=Obsidian
MimeType=x-scheme-handler/obsidian;
Categories=Office;
" > /home/$SUDO_USER/.local/share/applications/obsidian.desktop
chmod 555 /home/$SUDO_USER/.local/share/applications/obsidian.desktop
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/share/applications/obsidian.desktop
fi

