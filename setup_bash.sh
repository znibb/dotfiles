#!/bin/bash

## Install bash config files
script_path=$(dirname $(realpath $0))
FILES=".bash_aliases
.bash_logout
.bashrc"

cd $HOME

for filename in $FILES; do
	ln -s -f -v $script_path/bash/$filename $filename
done

## Install synth-shell for pretty prompt
# Install required font if not present
dpkg -l fonts-powerline > /dev/null 2>&1 || sudo apt install fonts-powerline

# Prepare config folder structure
mkdir -p ~/.config/synth-shell/colours

# Copy/link files in place
cd ~/.config/synth-shell
cp $script_path/bash/synth-shell/how-to-colour-override.txt .
cp $script_path/bash/synth-shell/synth-shell-prompt.sh .
cp $script_path/bash/synth-shell/colours/* colours/
ln -s -f -v $script_path/bash/synth-shell/synth-shell-prompt.config synth-shell-prompt.config