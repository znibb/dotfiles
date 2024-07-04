#!/bin/bash

script_path=$(dirname $(realpath $0))

dpkg -l tmux > /dev/null 2>&1 || sudo apt install tmux

cd $HOME

ln -s -f $script_path/tmux/.tmux.conf .tmux.conf