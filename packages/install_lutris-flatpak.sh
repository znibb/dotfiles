#!/bin/bash

bin_name=lutris
desktop_name=Lutris
flatpak_name=net.lutris.Lutris

# Ensure flatpak is installed
which flatpak > /dev/null || sudo apt install -y flatpak

# Ensure flathub repo is installed
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null

# Install
which $bin_name > /dev/null 2>&1 || flatpak install -y flathub $flatpak_name

# Create symlink to /use/bin
sudo ln -s -f /var/lib/flatpak/exports/bin/$flatpak_name /usr/bin/$bin_name

# Prepare icon file
sudo cp ./icons/$bin_name.png ~/.local/share/icons/$bin_name.png

# Create desktop file
echo "
[Desktop Entry]
Type=Application
Terminal=false
Icon=/usr/share/icons/$bin_name.png
Name=$desktop_name
Exec=/usr/bin/$bin_name
Categories=Utility;
" | sudo tee ~/.local/share/applications/$bin_name.desktop > /dev/null
