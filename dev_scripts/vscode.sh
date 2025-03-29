#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

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

