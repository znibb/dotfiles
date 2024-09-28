#!/bin/bash

which lazygit > /dev/null
if [[ $? -ne 0 ]]; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" > /dev/null
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit.tar.gz lazygit
fi
