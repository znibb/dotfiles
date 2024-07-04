#!/bin/bash

script_path=$(dirname $(realpath $0))

dpkg -l vim > /dev/null 2>&1 || sudo apt install vim

cd $HOME

ln -s -f $script_path/vim/.vimrc .vimrc