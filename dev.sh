#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y build-essential pip libusb-dev libusb-1.0-0-dev  

# ======= VSCODE Setup ========
#curl -L -o code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
#sudo apt install ./code.deb
#rm -f code.deb
snap install code --classic
su $SUDO_USER -c "code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension ms-vscode.remote-explorer"
exit
# ======= Arduino Setup ========
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

# ======= Serial Setup ========
apt install minicom picoterm putty -y
snap install tio --classic


# ======= Language setup ========
# rust
if command -v rustup >&2; then
  echo "rustup already installed"
else
  su $SUDO_USER -c "curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -ssf | sh -s -- -y"
  sed -i '/-- rust_analyzer/s/-- //' /home/$SUDO_USER/.config/nvim/init.lua

fi


