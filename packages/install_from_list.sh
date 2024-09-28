#!/bin/bash

# Iterate over lists in arguments
for arg in "$@"; do
  echo "Processing $arg"
  for package in $(cat $arg); do
    which $package > /dev/null || echo "Installing $package" && sudo apt-get install -y $package > /dev/null
  done
done
