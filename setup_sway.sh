#!/bin/bash

source_path=$(dirname $(realpath $0))
target_path=~/.config/sway

# Install sway package if not already available
dpkg -l sway > /dev/null 2>&1 || sudo apt install -y sway

# Link config file
cd $HOME
mkdir -p $target_path
ln -s $source_path/config $target_path/config
