# Dotfiles

## Fresh Arch PC install
### Pre archinstall
1. `iwctl`, to enter iwctl prompt
2. `device list`, to list devices
3. `device NAME set-property Powered on` (if NAME isn't already powered on)
4. `station NAME scan`, to scan for networks
5. `station NAME get-networks`, to show available networks
6. `station NAME connect SSID`, to connect to SSID (input password when prompted)
7. `ip a`, to chat that you have an assigned ip

### Archinstall
1. Locale -> Keyboard layout: sv-latin1
2. Mirror -> Mirror region: Sweden
3. Disk partitioning -> Partitioning: Whatever suits your fancy
4. Bootloader: Grub
5. Root password: Make sure to set it
6. User account: Create one for yourself but do **not** make it a SuperUser (we want to handle this through the sudo group instead)
7. Profile:
   1. Type -> Desktop: Your DE of preference (prefer `polkit` over `seatd`)
   2. Graphics driver: Adjust for your hardware
   3. Greeter: Personal preference, will assume `lightdm-slick-greeter`
8. Audio: Pipewire
9. Network: `Copy ISO network configuration to installation` (assuming you have your desired connectivity at time of setup)
10. Additional packages: `git ansible vim`
11. Timezone: `Europe/Berlin`
12. Install

After the install finishes agree to enter chroot and add your personal user account to `sudo` group and allow members of that group to use the sudo command:
1. Create sudo (system) group: `groupadd --system sudo`
2. Add user to the group: `usermod -aG sudo <USERNAME>`
3. Use `visudo` to enable members of the `sudo` group to use the sudo command (check for the row `%sudo ALL=(ALL:ALL) ALL`)
4. Exit out of the chroot with `exit` and poweroff to remove the booted installation media

### Setting up dotfiles
Clone dotfiles repo: `git clone https://github.com/znibb/dotfiles .dotfiles`
Install the required ansible collections: `ansible-galaxy install -r requirements.yml`

## Help
To see all available ansible_facts: `ansible <hostname> -m ansible.builtin.setup`