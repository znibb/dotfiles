#!/bin/bash

mkdir -p ./roles/$1/{files,tasks,vars}
touch ./roles/$1/tasks/main.yml
touch ./roles/$1/vars/main.yml
echo "$1_config_dir: \"{{ ansible_env.HOME }}/.config/$1\"" > ./roles/$1/vars/main.yml