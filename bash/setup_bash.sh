#!/bin/bash

# Install bash config files
script_path=$(dirname $(realpath $0))
FILES=".bash_aliases
.bash_logout
.bashrc"

cd $HOME

for filename in $FILES; do
	ln -s -v $script_path/$filename $filename
done

# Install synth-shell for pretty prompt
sudo apt install fonts-powerline
mkdir -p ~/.config/synth-shell
cd ~/.config/synth-shell
cp $script_path/synth-shell/synth-shell-prompt.sh .
ln -s -v $script_path/synth-shell/synth-shell-prompt.config synth-shell-prompt.config
