#!/bin/bash

source_path=$(dirname $(realpath $0))
target_path=~/.config/alacritty

# Install alacritty package if not already available
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt install -y alacritty


# Link config file
cd $HOME
mkdir -p $target_path
ln -s $source_path/alacritty.toml $target_path/alacritty.toml
