#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config/waybar

# Install waybar package if not already available
which waybar > /dev/null 2>&1 || sudo apt-get install -y waybar

# Install fonts-powerline for icons
#fc-list | grep Powerline > /dev/null 2>&1 || sudo apt-get install -y fonts-powerline

# Install custom fonts as well
sudo cp fonts/*.ttf /usr/local/share/fonts

# Refresh font cache
fc-cache -fv > /dev/null

# Link config files
mkdir -p $target_path
ln -s -f $script_path/waybar/config $target_path/config
ln -s -f $script_path/waybar/style.css $target_path/style.css
ln -s -f $script_path/waybar/modules.json $target_path/modules.json
