## Installation order
1. Packages (system/desktop)
1. Scripts
1. Sway
1. Swaybar
1. Alacritty
1. Nvim
1. Zsh
1. Packages misc

## Set SDDM account icon
Go to `./icons` and run `./set-login-icon.sh <ICON_FILE>

## Wifi with wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "<SSID>"
set_network 0 psk "<password>"
enable_network 0
save_config
quit

## Setup swap from file
### Disable swap if active, check with 'free'
sudo swapoff -a

### Remove old swap file if present
sudo rm /swapfile

### Create swap file, 2xRAM as rule of thumb
sudo fallocate -l 32G /swapfile

### Set permissions for swap file
sudo chmod 600 /swapfile

### Format file as swap
sudo mkswap -L swap /swapfile

### Enable swap
sudo swapon /swapfile

### Verify that swap is active
sudo swapon --show

### Set swappiness to 20 (recommende for desktop systems)
echo "vm.swappiness=20" | sudo tee -a /etc/sysctl.conf

### Check which device your swap file is mounted on (e.g. /dev/nvme0n1p2)
df -h

### Find the physical offset of the swap file
sudo filefrag -v /swapfile | awk '{ print $4 }' | head -4 | tail -1 | sed 's/.\{2\}$//'

### Update grub settings
sudo vim /etc/default/grub
Add `resume=/dev/<root_disk> resume_offset=<offset_from_above> to the `GRUB_CMDLINE_DEFAULT_LINUX` string

### Update grub
sudo update-grub

### Test hibernate
sudo systemctl hibernate
If it doesn't work check that Secure Boot is DISABLED

## Update BIOS
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update

## Change SDDM theme
Store themes in ./sddm/ and use `setup_sway.sh` to copy them to /usr/share/sddm/themes

Set theme by adding the following to /etc/sddm.conf:
```
[Theme]
Current=THEME-NAME
```

## Wallpaper
Change wallpaper by symlinking desired wallpaper to ~/.config/wallpaper/wallpaper
