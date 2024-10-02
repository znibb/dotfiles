## Wifi with wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "<SSID>"
set_network 0 psk "<password>"
enable_network 0
save_config
quit

## Setup swap from file
# Disable swap if active, check with 'free'
sudo swapoff

# Create swap file, 2xRAM as rule of thumb
sudo fallocate -l 32G /swapfile

# Set permissions for swap file
sudo chmod 600 /swapfile

# Format file as swap
sudo mkswap -L swap /swapfile

# Enable swap
sudo swapon /swapfile

# Verify that swap is active
sudo swapon --show

# Set swappiness to 20 (recommende for desktop systems)
echo "vm.swappiness=20" | sudo tee -a /etc/sysctl.conf

# Check which device your swap file is mounted on (e.g. /dev/nvme0n1p2)
df -h

# Find the physical offset of the swap file
sudo filefrag -v /swapfile | awk '{ print $4 }' | head -4 | tail -1 | sed 's/.\{2\}$//'

## Change SDDM theme
Store themes in ./sddm/ and use `setup_sway` to copy them to /usr/share/sddm/themes

Set theme by adding the following to /etc/sddm.conf:
```
[Theme]
Current=THEME-NAME
```

# Wallpaper
Change wallpaper by symlinking desired wallpaper to ~/.config/wallpaper/wallpaper
