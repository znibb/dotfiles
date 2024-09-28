#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config/zsh

# Install package if not already available
which zsh > /dev/null 2>&1 || sudo apt install -y zsh

# Add zsh config location to .profile
grep "export ZDOTDIR" ~/.profile > /dev/null|| echo '
# Set zsh config dir
export ZDOTDIR=$HOME/.config/zsh' | tee -a ~/.profile > /dev/null

# Install oh-my-zsh
[ -d $target_path/ohmyzsh ] || sh -c "ZSH=$HOME/.config/zsh/ohmyzsh $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && sleep 5s

# Link config files
mkdir -p $target_path
ln -s -f $script_path/zsh/.zshrc $target_path/.zshrc
ln -s -f $script_path/zsh/.aliases $target_path/.aliases

# Change default shell
sudo chsh -s $(which zsh) $USER
