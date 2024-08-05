#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

secDir = "/home/$SUDO_USER/Sec_Tools"
mkdir $secDir

# =======  Setup ========
apt install -y gnuradio gqrx-sdr 
#apt install -y nmap
sudo snap install nmap
sudo snap connect nmap:network-control

# ======= Wireshark Setup ========
if ! command -v wireshark >&2; then
  sudo add-apt-repository ppa:wireshark-dev/stable -y
  sudo apt update
  DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark > /dev/null
  apt install -y tshark
  sudo usermod -a -G wireshark "$SUDO_USER"
fi

# ======= RTL-SDR Setup ========
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

# ======= Kismet Setup ========
if ! command -v kismet >&2; then
  wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key --quiet | gpg --dearmor | sudo tee /usr/share/keyrings/kismet-archive-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/noble noble main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  sudo apt update
  #sudo apt install kismet -y
  DEBIAN_FRONTEND=noninteractive apt-get -y install kismet > /dev/null
  sudo usermod -aG kismet $SUDO_USER
else
  echo "kismet already installed"
fi

# ======= Universal Radio Hacker Setup ========
if ! command -v urh >&2; then
    pipx install urh
    pipx ensurepath
    cd $WDIR
    sudo cp 10-rtl-sdr.rules /etc/udev/rules.d
else
    echo "urh already installed"
fi

# ======= Flipper Setup ========
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
