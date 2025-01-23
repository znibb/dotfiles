# Dotfiles

## Fresh Arch PC install
### Archinstall
1. Locale:
   1. Keyboard layout: sv-latin1
   2. Locale language: en_US (default)
   3. Locale encoding: UTF-8 (default)
2. Mirror -> Mirror region: Sweden
3. Disk partitioning -> Partitioning: Whatever suits your fancy
4. Root password: Make sure to set it
5. User account: Create one for yourself but do **not** make it a SuperUser (we want to handle this through the sudo group instead)
6. Profile:
   1. Type -> Desktop: Your DE of preference
   2. Graphics driver: Adjust for your hardware
   3. Greeter: Personal preference, will assume `lightdm-slick-greeter`
7. Audio: Pipewire
8. Network: `Copy ISO network configuration to installation` (assuming you have your desired connectivity at time of setup)
9. Timezone: `Europe/Berlin`
10. Additional packages: `git ansible`
11. Install

After the install finishes agree to enter chroot and add your personal user account to `sudo` group and allow members of that group to use the sudo command:
1. Create sudo (system) group: `groupadd --system sudo`
2. Add user to the group: `usermod -aG sudo <USERNAME>`
3. Use `visudo` to enable members of the `sudo` group to use the sudo command (check for the row `%sudo ALL=(ALL:ALL) ALL`)
4. Exit out of the chroot with `exit` and poweroff to remove the booted installation media

### Setting up dotfiles
Install the required ansible collections: `ansible.galaxy install -r requirements.yml`

## Help
To see all available ansible_facts: `ansible <hostname> -m ansible.builtin.setup`