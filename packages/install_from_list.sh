#!/bin/bash

# Iterate over lists in arguments
for arg in "$@"; do
  echo ">>> Processing $arg"
  sudo apt-get install $(grep -vE "^\s*#" $arg | tr "\n" " ")
done
