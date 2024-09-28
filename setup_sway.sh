#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config/sway

# Install sway package if not already available
which sway > /dev/null 2>&1 || sudo apt install -y sway

# Link config file
cd $HOME
mkdir -p $target_path
ln -s -f $script_path/sway/config $target_path/config

# Update sway-desktop to launch bootstrap script
sudo sed -i -e 's/^Exec=sway$/Exec=sway-bootstrap/g' /usr/share/wayland-sessions/sway.desktop

# Link bootstrap script to /usr/local/bin
sudo ln -s -f $script_path/sway/sway-bootstrap /usr/local/bin/sway-bootstrap
