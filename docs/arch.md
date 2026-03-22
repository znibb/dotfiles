## Arch
### Pre archinstall
1. `iwctl`, to enter iwctl prompt
1. `device list`, to list devices
1. `device NAME set-property Powered on` (if NAME isn't already powered on)
1. `station NAME scan`, to scan for networks
1. `station NAME get-networks`, to show available networks
1. `station NAME connect SSID`, to connect to SSID (input password when prompted)
1. Exit `iwctl` and run `ip a` to check that you have an assigned ip

### Archinstall
1. Locale -> Keyboard layout: `sv-latin1`
1. Mirror -> Mirror region: `Sweden`
1. Disk partitioning -> Partitioning: Whatever suits your fancy
1. Bootloader: `Grub`
1. Root password: Make sure to set it
1. User account: Create one for yourself but do **not** make it a SuperUser (we want to handle this through the sudo group instead)
1. Profile:
   1. Type -> Desktop: KDE
   1. Graphics driver: Adjust for your hardware
   1. Greeter: sddm
1. Audio: Pipewire
1. Network: `Copy ISO network configuration to installation` (assuming you have your desired connectivity at time of setup)
1. Additional packages: `git ansible vim`
1. Timezone: `Europe/Berlin`
1. Install

After the install finishes agree to enter chroot and add your personal user account to `sudo` group and allow members of that group to use the sudo command:
1. Create sudo (system) group: `groupadd --system sudo`
1. Add user to the group: `usermod -aG sudo <USERNAME>`
1. Use `visudo` to enable members of the `sudo` group to use the sudo command (check for the row `%sudo ALL=(ALL:ALL) ALL`)
1. Exit out of the chroot with `exit` and poweroff to remove the booted installation media

### Setting up dotfiles
1. On your new machine, create an ssh key-pair by going go `~/.ssh` and running `ssh-keygen -t ed25519 -C "USER@HOST" -f github-USERNAME` and then log into your GitHub account and add the public key to `Authentication keys`.
1. Clone dotfiles repo: `git clone git@github.com:znibb/dotfiles.git ~/.dotfiles`
1. Enter the dotfiles directory and install the required ansible collections: `ansible-galaxy install -r requirements.yml`
1. Run the ansible playbook: `ansible-playbook -i inventory/hosts.ini hosts-HOSTNAME.yml`