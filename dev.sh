#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi


# =======  Setup ========
apt install -y build-essential pip libusb-1.0-0-dev 

curl -L -o code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install ./code.deb
rm -f code.deb

wget -O arduino.zip https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.2_Linux_64bit.zip?_gl=1*s72ek3*_ga*Njk5MzEzNjE1LjE3MjI2MzQ3MTg.*_ga_NEXN8H46L5*MTcyMjYzNDcxNy4xLjAuMTcyMjYzNDcyMi4wLjAuMTkwMDUwMzkwNw..*_fplc*blBTbjhZSml0TGpvM05sdlR1TzJrUFQlMkI4NFhjNEV4eFhVektGU29wdDJCaGUlMkZBNGVmS0Z6aWN4S1BkU2o4c1BOaTMzblE3aGdCOENDdlRSRUZ4Q0kwSU81amc3bEJtTGxWMGw0QkdhaDZmVWdsWVdZME8zZG5FRGpidDN3QSUzRCUzRA..*_gcl_au*Njg1MTY1MzY5LjE3MjI2MzQ3MjI.
unzip arduino.zip -d -o /usr/local/bin
mv -f /usr/local/bin/arduino-ide* /usr/local/bin/arduino

chown root:root /usr/local/bin/arduino/chrome-sandbox
chmod 4755 /usr/local/bin/arduino/chrome-sandbox

arduinoPath="/usr/local/bin/arduino"
if ! grep -q "$arduinoPath" /etc/environment; then
    sudo sh -c "echo 'PATH=\"$(grep -oP 'PATH=\"\K[^\"]*' /etc/environment):$arduinoPath\"' > /etc/environment"
    echo "Updated /etc/environment with new PATH: $arduinoPath"
else
    echo "Path $arduinoPath is already in /etc/environment"
fi

echo '
[Desktop Entry]
Version=1.0
Name=Arduino IDE
Comment=Write code and flash to Arduino hardware
GenericName=Embedded electronics IDE
Keywords=Programming;Development
Exec=/usr/local/bin/arduino/arduino-ide
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/local/bin/arduino/resources/app/resources/icons/512x512.png
MimeType=text/x-arduino;
StartupNotify=true
' > /home/$SUDO_USER/.local/share/applications/arduino.desktop
chmod 555 /home/$SUDO_USER/.local/share/applications/arduino.desktop

rm arduino.zip
