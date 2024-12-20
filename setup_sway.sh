#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config

# Install sway package if not already available
which sway > /dev/null 2>&1 || sudo apt-get install -y sway
mkdir -p $target_path/sway
ln -s -f $script_path/sway/sway-config $target_path/sway/config
ln -s -f $script_path/sway/config.d $target_path/sway

# Update sway.desktop to launch bootstrap script
sudo sed -i -e 's/^Exec=sway$/Exec=sway-bootstrap/g' /usr/share/wayland-sessions/sway.desktop

# Link bootstrap script to /usr/local/bin
sudo ln -s -f $script_path/sway/sway-bootstrap /usr/local/bin/sway-bootstrap

# Install wallpapers
ln -s -f $script_path/wallpapers $target_path

# Add sudoers file to enable use of systemctl without sudo password
echo "$USER ALL= NOPASSWD: /bin/systemctl hibernate" | sudo tee /etc/sudoers.d/systemctl-sway > /dev/null

# Install swayidle for screen timeout
which swayidle > /dev/null 2>&1 || sudo apt-get install -y swayidle

# Install swaylock for lock screen
which swaylock > /dev/null 2>&1 || sudo apt-get install -y swaylock
ln -s -f $script_path/sway/swaylock.conf $target_path/sway/swaylock.conf
ln -s -f $script_path/sway/lock.sh $target_path/sway/lock.sh

# Install sway notification center
which swaync > /dev/null 2>&1 || sudo apt-get install -y sway-notification-center
mkdir -p $target_path/swaync
ln -s -f $script_path/sway/swaync/config.json $target_path/swaync/config.json
ln -s -f $script_path/sway/swaync/configSchema.json $target_path/swaync/configSchema.json
ln -s -f $script_path/sway/swaync/style.css $target_path/swaync/style.css

# Install wofi (launcher/menu program)
which wofi > /dev/null 2>&1 || sudo apt-get install -y wofi
mkdir -p $target_path/wofi
ln -s -f $script_path/sway/wofi-style.css $target_path/wofi/style.css

# Install wdisplays for GUI display management
which wdisplays > /dev/null 2>&1 || sudo apt-get install -y wdisplays

# Install brightnessctl (for adjusting screen brightness)
which brightnessctl > /dev/null 2>&1 || sudo apt-get install -y brightnessctl

# Add user to video group (to be able to adjust brightness)
sudo usermod -a -G video $USER

# Install playerctl for media controls
which playerctl > /dev/null 2>&1 || sudo apt-get install -y playerctl

# Install wob for progress bars
which wob > /dev/null 2>&1 || sudo apt-get install -y wob

# Copy sddm themes to system dir
sudo cp -r $script_path/sddm/* /usr/share/sddm/themes

# Set custom theme if not already done
grep "\[Theme\]" /etc/sddm.conf > /dev/null 2>&1 || echo "
[Theme]
Current=Bluish-SDDM" | sudo tee -a /etc/sddm.conf
