#!/bin/bash

script_path=$(dirname $(realpath $0))
target_path=~/.config

# Install sway package if not already available
which sway > /dev/null 2>&1 || sudo apt-get install -y sway

# Install wofi (launcher/menu program)
which wofi > /dev/null 2>&1 || sudo apt-get install -y wofi

# Install wdisplay for GUI display management
which wdisplays > /dev/null 2>&1 || sudo apt-get install -y wdisplays

# Install brightnessctl (for adjusting screen brightness)
which brightnessctl > /dev/null 2>&1 || sudo apt-get install -y brightnessctl

# Install playerctl for media controls
which playerctl > /dev/null 2>&1 || sudo apt-get install -y playerctl

# Install wob for progress bars
which wob > /dev/null 2>&1 || sudo apt-get install -y wob

# Install swayidle for screen timeout
which swayidle > /dev/null 2>&1 || sudo apt-get install -y swayidle

# Install sddm-conf for login screen config GUI
which sddm-conf > /dev/null 2>&1 || sudo apt-get install -y sddm-conf

# Copy sddm themes to system dir
sudo cp -r $script_path/sddm/* /usr/share/sddm/themes

# Set up icons for login screen usage
ln -s -f $script_path/icons $target_path/icons
ln -s $target_path/icons/default.icon $HOME/.face.icon

# Install swaylock for lock screen
which swaylock > /dev/null 2>&1 || sudo apt-get install -y swaylock
cp $script_path/sway/lock.png $target_path/
ln -s -f $script_path/sway/swaylock.conf $target_path/sway/swaylock.conf

# Add user to video group (to be able to adjust brightness)
sudo usermod -a -G video $USER

# Link config files
mkdir -p $target_path/sway
mkdir -p $target_path/wofi
ln -s -f $script_path/sway/sway-config $target_path/sway/config
ln -s -f $script_path/sway/config.d $target_path/sway/config.d
ln -s -f $script_path/sway/input_devices.conf $target_path/sway/config.d/input_devices.conf
ln -s -f $script_path/sway/special_keys.conf $target_path/sway/config.d/special_keys.conf
ln -s -f $script_path/sway/wofi-style.css $target_path/wofi/style.css

# Update sway-desktop to launch bootstrap script
sudo sed -i -e 's/^Exec=sway$/Exec=sway-bootstrap/g' /usr/share/wayland-sessions/sway.desktop

# Link bootstrap script to /usr/local/bin
sudo ln -s -f $script_path/sway/sway-bootstrap /usr/local/bin/sway-bootstrap

# Add sudoers file to enable use of systemctl without sudo password
#sudo cp $script_path/sway/systemctl-sway /etc/sudoers.d/
echo "$USER ALL= NOPASSWD: /bin/systemctl hibernate" | sudo tee /etc/sudoers.d/systemctl-sway > /dev/null
