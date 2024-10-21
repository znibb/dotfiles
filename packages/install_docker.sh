#!/bin/bash

exe_name=docker

if ! which $exe_name > /dev/null; then
  # Install packages
  sudo apt install -y docker-compose-v2 docker.io

  # Create docker group if it doesnt exist
  if ! getent group docker > /dev/null; then
    sudo groupadd docker
  fi

  # Add user to docker group if not already a member
  if ! id -nG $USER | grep docker > /dev/null; then
    sudo usermod -aG docker $USER
  fi

  # Hint user to relog/restart
  echo "Done! You will need to relog/restart for the changes to take effect."
fi
