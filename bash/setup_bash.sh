#!/bin/bash

script_path=$(dirname $(realpath $0))
FILES=".bash_aliases
.bash_logout
.bashrc"

cd $HOME

for filename in $FILES; do
	ln -s -v $script_path/$filename $filename
done
