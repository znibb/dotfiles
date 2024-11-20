#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config

# Install package if not already available
which zsh > /dev/null 2>&1 || sudo apt install -y zsh

# Add zsh config location to .profile
grep "export ZDOTDIR" ~/.profile > /dev/null || echo '
# Set zsh config dir
export ZDOTDIR=$HOME/.config/zsh' | tee -a ~/.profile > /dev/null

# Install starship if not already available
which /usr/local/bin/starship > /dev/null 2>&1 || curl -sS https://starship.rs/install.sh | sh

# Link config files
mkdir -p $target_path/zsh
ln -s -f $script_path/zsh/.zshrc $target_path/zsh/.zshrc
ln -s -f $script_path/zsh/.aliases $target_path/zsh/.aliases
ln -s -f $script_path/zsh/starship.toml $target_path/starship.toml

# Change default shell
sudo chsh -s $(which zsh) $USER
