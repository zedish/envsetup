#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

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

