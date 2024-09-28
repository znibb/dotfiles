#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config/alacritty

# Install alacritty package if not already available
which alacritty > /dev/null 2>&1 || sudo apt install -y alacritty


# Link config file
mkdir -p $target_path
ln -s -f $script_path/alacritty/alacritty.toml $target_path/alacritty.toml
