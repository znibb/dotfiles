#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config/nvim

# Install alacritty package if not already available
which nvim > /dev/null 2>&1 || sudo apt install -y neovim wl-clipboard

# Link config file
mkdir -p $target_path
ln -s -f $script_path/nvim/init.lua $target_path/init.lua
