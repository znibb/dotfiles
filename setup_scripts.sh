#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.scripts

for file in $(ls ./scripts); do
  ln -s -f $script_path/scripts/$file $target_path/$file
done
