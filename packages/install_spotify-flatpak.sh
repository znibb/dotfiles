#!/bin/bash

# Ensure flatpak is installed
which flatpak > /dev/null || sudo apt install -y flatpak

# Ensure flathub repo is installed
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo > /dev/null

# Install
flatpak install -y flathub com.spotify.Client > /dev/null 2>&1

# Create symlink to /use/bin
sudo ln -s -f /var/lib/flatpak/exports/bin/com.spotify.Client /usr/bin/spotify
