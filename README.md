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
1. Locale -> Keyboard layout: `sv-latin1`
2. Mirror -> Mirror region: `Sweden`
3. Disk partitioning -> Partitioning: Whatever suits your fancy
4. Bootloader: `Grub`
5. Root password: Make sure to set it
6. User account: Create one for yourself but do **not** make it a SuperUser (we want to handle this through the sudo group instead)
7. Profile:
   1. Type -> Desktop: Hyprland (prefer `polkit` over `seatd`)
   2. Graphics driver: Adjust for your hardware
   3. Greeter: sddm (to make initial hyprland install able to start)
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

At a later stage set up an ssh key-pair with Github and run `git remote set-url origin git@github.com:znibb/dotfiles.git` to be able to push to the repo without password (remember to set up ssh config)  

Install the required ansible collections: `ansible-galaxy install -r requirements.yml`

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
2. Set proper permissions, `sudo chmod 600 /swapfile`
3. Format file to be used as swap, `sudo mkswap /swapfile`
4. Enable swap, `sudo swapon /swapfile`
5. Enable swap no reboot by adding the following to `/etc/fstab`, `/swapfile none swap defaults 0 0`
6. Find swap file UUID, `findmnt -no UUID -T /swapfile`
7. Find swap file offset, `sudo filefrag -v /swapfile| awk '$1=="0:" {print substr($4, 1, length($4).2)}'`
8. Add the following to `GRUB_CMDLINE_LINUX` (not `_DEFAULT`) in `/etc/default/grub`, `resume=UUID=<swap_file_uuid> resume_offset=<swap_file_offset>`
9. Generate new grub.cfg (and overwrite the old one), `sudo grub-mkconfig -o /boot/grub/grub.cfg`
10. Edit `/etc/mkinitcpio.conf`and add `resume` to the list of hooks, e.g. `HOOKS=(base udev resume autodetect ...)`
11. Build new initramfs, `sudo mkinitcpio -P`

### Syncing Office365 calendar with Thunderbird
1. In Thunderbird go to `Settings->Addons and Themes`, scroll to the bottom and click `Find more add-ons`
2. Search for and install `TbSync` and `Provider for Exchange ActiveSync`
3. Go to the Calendar view in Thunderbird and click `TbSync: Idle` at the bottom-right of the window
4. Click `Account actions->Add new account->Exchange ActiveSync`
5. Check `Enable and syncronize this account`, tick the `Calendar`checkbox in the list below and then click `Syncronize now`

### Add ChatGPT search in KRunner
1. Go to `System Settings->Plasma Search`, scroll down to `Web Search Keywords` and click `Configure...`
1. Create a new keyword:
   Name: `ChatGPT`
   URL: `https://chatgpt.com/?model=gpt-4o&q=\{@}`
   Keywords: `ai`