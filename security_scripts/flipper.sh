#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if ! [ -f /home/$SUDO_USER/.local/share/applications/qflipper.desktop ]; then
  wget -nc -P /home/$SUDO_USER/.local/bin https://update.flipperzero.one/builds/qFlipper/1.3.3/qFlipper-x86_64-1.3.3.AppImage
  chmod u+x /home/$SUDO_USER/.local/bin/qFlipper-x86_64-1.3.3.AppImage
  chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/bin/qFlipper-x86_64-1.3.3.AppImage
  /home/$SUDO_USER/.local/bin/qFlipper-x86_64-1.3.3.AppImage --appimage-extract
  mv squashfs-root/usr/share/icons/hicolor/512x512/apps/qFlipper.png /home/$SUDO_USER/.local/share/icons
  rm -rf squashfs-root
  echo "
[Desktop Entry]
Type=Application
StartupWMClass=qFlipper
Categories=Utility;Education
Comment=Update your Flipper easily
Icon=/home/$SUDO_USER/.local/share/icons/qFlipper.png
Name=qFlipper
Exec=/home/$SUDO_USER/.local/bin/qFlipper-x86_64-1.3.3.AppImage
Terminal=false
X-AppImage-Version=bfce851
" > /home/$SUDO_USER/.local/share/applications/qflipper.desktop
chmod 555 /home/$SUDO_USER/.local/share/applications/qflipper.desktop
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/share/applications/qflipper.desktop
fi

