#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

if ! [ -f /home/$SUDO_USER/.local/share/applications/arduino.desktop ]; then
  wget -nc -P /home/$SUDO_USER/.local/bin https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.2_Linux_64bit.AppImage
  chmod u+x /home/$SUDO_USER/.local/bin/arduino-ide_2.3.2_Linux_64bit.AppImage
  chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/bin/arduino-ide_2.3.2_Linux_64bit.AppImage
  /home/$SUDO_USER/.local/bin/arduino-ide_2.3.2_Linux_64bit.AppImage --appimage-extract
  mv squashfs-root/resources/app/resources/icons/512x512.png /home/$SUDO_USER/.local/share/icons/arduino-ide.png
  rm -rf squashfs-root
  echo "
[Desktop Entry]
Name=Arduino IDE
Exec=/home/$SUDO_USER/.local/bin/arduino-ide_2.3.2_Linux_64bit.AppImage --no-sandbox %U
Terminal=false
Type=Application
Icon=/home/$SUDO_USER/.local/share/icons/arduino-ide.png
StartupWMClass=Arduino IDE
X-AppImage-Version=2.3.2
Comment=Arduino IDE
Categories=Development;
" > /home/$SUDO_USER/.local/share/applications/arduino.desktop
chmod 555 /home/$SUDO_USER/.local/share/applications/arduino.desktop
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/share/applications/arduino.desktop
fi

