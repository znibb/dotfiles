#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config

# Install sway package if not already available
which sway > /dev/null 2>&1 || sudo apt-get install -y sway

# Install wofi (launcher/menu program)
which wofi > /dev/null 2>&1 || sudo apt-get install -y wofi

# Install wdisplay for GUI display management
which wdisplay > /dev/null 2>&1 || sudo apt-get install -y wdisplay

# Install brightnessctl (for adjusting screen brightness)
which brightnessctl > /dev/null 2>&1 || sudo apt-get install -y brightnessctl

# Install wob for progress bars
which wob > /dev/null 2>&1 || sudo apt-get install -y wob

# Install swayidle for screen timeout
which swayidle > /dev/null 2>&1 || sudo apt-get install -y swayidle

# Install swaylock for lock screen
which swaylock > /dev/null 2>&1 || sudo apt-get install -y swaylock

# Add user to video group (to be able to adjust brightness)
sudo usermod -a -G video $USER

# Link config file
mkdir -p $target_path/sway/config.d
mkdir -p $target_path/wofi
ln -s -f $script_path/sway/sway-config $target_path/sway/config
ln -s -f $script_path/sway/input_devices.conf $target_path/sway/config.d/input_devices.conf
ln -s -f $script_path/sway/special_keys.conf $target_path/sway/config.d/special_keys.conf
ln -s -f $script_path/sway/wofi-style.css $target_path/wofi/style.css

# Update sway-desktop to launch bootstrap script
sudo sed -i -e 's/^Exec=sway$/Exec=sway-bootstrap/g' /usr/share/wayland-sessions/sway.desktop

# Link bootstrap script to /usr/local/bin
sudo ln -s -f $script_path/sway/sway-bootstrap /usr/local/bin/sway-bootstrap
