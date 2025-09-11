# Dotfiles

## Fresh Arch PC install
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
   1. Type -> Desktop: Hyprland (prefer `polkit` over `seatd`)
   1. Graphics driver: Adjust for your hardware
   1. Greeter: sddm (to make initial hyprland install able to start)
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

## Alpine specific
If you run `sudo apk update` and the output contains warnings about stale repos or if your ansible-playbook runs fails with something like `fatal: [localhost]: FAILED! => {"changed": false, "msg": "could not update package db"` one solution is to run `sudo setupapkrepos -cf` to scan for available/suitable repo mirrors to use

You might need to run `sudo apk update`, check which mirrors it's complaining about and manually remove them from `/etc/apk/repositories`


## Help
To see all available ansible_facts: `ansible <hostname> -m ansible.builtin.setup`

### Running specific roles
To enable debugging of a certain role it could be benefitial to run just a specific role and not the entire playbook. This can be achieved by editing the relevant playbook and adding a tag for the role in question, e.g. replace:
```
   - roleName
```
with
```
   { role: roleName, tags: roleName }
```
will let you invoke only that specific role with `ansible-playbook playbook.yml --tags roleName` (or `--tags "role1,role2" for multiple specific roles)

### Setting up swap
1. Create file to use as swap, `sudo fallocate -l 30G /swapfile`
1. Set proper permissions, `sudo chmod 600 /swapfile`
1. Format file to be used as swap, `sudo mkswap /swapfile`
1. Enable swap, `sudo swapon /swapfile`
1. Enable swap no reboot by adding the following to `/etc/fstab`, `/swapfile none swap defaults 0 0`
1. Find swap file UUID, `findmnt -no UUID -T /swapfile`
1. Find swap file offset, `sudo filefrag -v /swapfile| awk '$1=="0:" {print substr($4, 1, length($4).2)}'`
1. Add the following to `GRUB_CMDLINE_LINUX` (not `_DEFAULT`) in `/etc/default/grub`, `resume=UUID=<swap_file_uuid> resume_offset=<swap_file_offset>`
1. Generate new grub.cfg (and overwrite the old one), `sudo grub-mkconfig -o /boot/grub/grub.cfg`
1. Edit `/etc/mkinitcpio.conf`and add `resume` to the list of hooks, e.g. `HOOKS=(base udev resume autodetect ...)`
1. Build new initramfs, `sudo mkinitcpio -P`

### Syncing Office365 calendar with Thunderbird
1. In Thunderbird go to `Settings->Addons and Themes`, scroll to the bottom and click `Find more add-ons`
1. Search for and install `TbSync` and `Provider for Exchange ActiveSync`
1. Go to the Calendar view in Thunderbird and click `TbSync: Idle` at the bottom-right of the window
1. Click `Account actions->Add new account->Exchange ActiveSync`
1. Check `Enable and syncronize this account`, tick the `Calendar`checkbox in the list below and then click `Syncronize now`

### Add ChatGPT search in KRunner
1. Go to `System Settings->Plasma Search`, scroll down to `Web Search Keywords` and click `Configure...`
1. Create a new keyword:
   Name: `ChatGPT`
   URL: `https://chatgpt.com/?model=gpt-4o&q=\{@}`
   Keywords: `ai`