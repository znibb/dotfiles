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

## Artix
Instructions will assume a UEFI system (as opposed to one using BIOS).  

Start with going to `https://artixlinux.org/download.php` and download either the `base` ISO or the one corresponding to your desired Desktop Environment

### Setting up the machine
#### Using virt-manager
1. Start `virt-manager` and go to `File->New Virtual Machine`
1. Select `Local install media` and click `Forward`
1. Under `Choose ISO or CDROM install media` click `Browse...`
1. Select the previously downloaded ISO file, if not visible click `Browse Local` and locate it that way
1. Under `Choose the operating system you are installing` select `Generic Linux 2024 (linux2024)`, click `Forward`
1. Enter your desired amount of RAM and CPU core allocation, click `Forward`
1. Make sure `Enable storage for this virtual machine` is enabled, enter your desired amount of VM storage and click `Forward`
1. Enter a suitable name for the VM, enable `Customize configuration before install` and click `Finish`
1. In the `Overview` section go to `Hypervisor Details->Firmware` and select `UEFI`
1. Click `Apply` in the bottom right and then `Begin Installation` in the top left

#### Bare metal
1. Insert install media
1. ???
1. Profit?

### Artix install
#### Base install
##### Getting started
1. Select your desired `timezone`, `keytable` and `lang`, then select `From Stick/HDD: artix.x86_64`
1. When prompted log in as root//artix
1. Check available keyboard layouts with `ls -R /usr/share/kbd/keymaps` and load your preferred one with e.g. `loadkeys sv-latin1`

##### Disk partitioning
1. Check your available block devices with `lsblk`
1. Run `fdisk /dev/<device_name>`
1. Print the current partition table by entering `p`
1. Delete any existing partitions by entering `d` repeatedly
1. Enter `g` to create a new empty GPT partition table
1. Enter `n`to create a new partition
- Partition number: 1 (default)
- First sector: 2048 (default)
- Last sector: +1G
1. Enter `n` to create a new partition
- Partition number: 2
- First sector: 2099200 (default)
- Last sector, just press `Enter` to let the partition fill the remaining disk space
1. Enter `t` to change a partition type
- Partition number: 1
- Partition type: 1 (EFI System)
1. Enter `p` and double-check that you have two partitions:
- /dev/xxx1 of type `EFI System` with size 1G
- /dev/xxx2 of type `Linux filesystem` containing the remainder of the disk
1. Enter `w` to write to disk and exit

##### Format partitions
1. Format the intended EFI system partition as fat32: `mkfs.fat -F 32 /dev/xxx1 && fatlabel /dev/xxx1 ESP`
1. Format the intended root partition as ext4: `mkfs.ext4 -L ROOT /dev/xxx2`

##### Mount the target file system
1. Mount the root partition: `mount /dev/xxx2 /mnt`
1. Create the `/mnt/boot/efi` directory: `mkdir -p /mnt/boot/efi`
1. Mount the EFI system partition: `mount /dev/xxx1 /mnt/boot/efi`
1. Create a swapfile: `fallocate -l 4G /mnt/swapfile`
1. Fix file permissions: `chmod 600 /mnt/swapfile`
1. Format swapfile as swap: `mkswap -L SWAP /mnt/swapfile`
1. Enable swap: `swapon /mnt/swapfile`
1. Create the `mkdir -p /mnt/etc` directory: `mkdir -p /mnt/etc`
1. Generate fstab: `fstabgen -U /mnt >> /mnt/etc/fstab`
1. Verify that fstab contains entries for `/`, `/boot/efi` and the swapfile

##### Verify internet connection
1. Check connectivity by pinging e.g. `Google Public DNS`: `ping 8.8.8.8`
1. Wired connection should setup automatically, see [ArchWiki](https://wiki.archlinux.org/title/Network_configuration/Wireless) for instrucitons on how to get wireless working

##### Update system clock
1. Start the NTP daemon: `rc-service ntpd start`

##### Install and configure base system
1. Install base system package groups, kernel, firmware and (system) packages: `basestrap /mnt base base-devel openrc elogind-openrc linux linux-firmware grub efibootmgr networkmanager networkmanager-openrc vi git ansible`
1. Chroot into the target system: `artix-chroot /mnt`
1. Set the time zone: `ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
1. Generate `/etc/adjtime`: `hwclock --systohc`
1. Uncomment desired locales in `/etc/locale.gen`, e.g. using `sed`: `sed -i 's/^#en_US.UTF-8/en_US.UTF-8/; s/^#sv_SE.UTF-8/sv_SE.UTF-8/' /etc/locale.gen`
1. Generate locales: `locale-gen`
1. Set system-wide locale:
- echo `echo 'export LANG="en_US.UTF-8"' | tee -a /etc/locale.conf`
- echo `echo 'export LC_COLLATE="C"' | tee -a /etc/locale.conf`
1. Make keyboard layout settings persistent on target system: `sed -i 's/^keymap=.*/keymap=sv-latin1/' /etc/conf.d/keymaps`
1. Install GRUB into the target system: `grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub`
1. Generate GRUB config: `grub-mkconfig -o /boot/grub/grub.cfg`
1. Create hostname file: `echo "<hostname>" | tee /etc/hostname`
1. Also update openrc hostname fallback file: `sed -i 's/^hostname="localhost"/hostname="<hostname>"/' /etc/conf.d/hostname`
1. Set `root` password: `passwd`
1. Create `sudo` system group: `groupadd -r sudo`
1. Enable members of the `sudo` group to user the `sudo` command: `echo "%sudo ALL=(ALL:ALL) ALL" | tee -a /etc/sudoers.d/sudo_grp`
1. Create user account and add it to the `sudo` group: `useradd -m -G sudo <user>`
1. Set `<user>` password: `passwd <user>`
1. Disable `root` login: `sed -i 's/root:\/usr\/bin\/bash/root:\/sbin\/nologin/' /etc/passwd`

##### Finishing up
1. Exit chroot: `exit`
1. Unmount partitions: `umount -R /mnt`
1. Reboot: `reboot`

#### Plasma install
1. Select your desired `timezone`, `keytable` and `lang`, then select `From Stick/HDD: artix.x86_64`
1. When the desktop environment boots up double-click on the `Install Artix` shortcut on the desktop
1. Select `offline` and click `OK`
1. In the `Welcome` section of the installer let the language settings remain as `American English`, we will override appropriate sections of it later, click `Next`
1. In the `Location` section select your desired `Region` and `Zone`, update `numbers and dates locale` to `sv_SE.UTF_8`, click `Next`
1. In the `Keyboard` section select `Swedish->Default`
1. In the `Partitions` section select the intended storage device, select `Manual partitioning` and click `Next`
1. Click `New Partition Table`, `GUID Partition Table (GPT)` and click `OK`
1. Create the following partitions (in order):
- Size: 300 MiB, File System: `fat32`, Mount Point: `/boot/efi`, FS Label: `EFI`, Flags: `boot`
- Size: Default/remainder, File System: `ext4`, Mount Point: `/`, FS Label: `ROOT`
1. In the `Users` section set your name, username, hostname, password and root password, click `Next`
1. In the `Summary` section double check your config and click `Install`
1. When the install is finished and you end up in the `Finish` section, select `Restart now` and click `Done`

#### Setting up dotfiles
1. Log in with the credentials you set up during the Plasma install and open a terminal window (`Konsole`)
1. Since `linux-firmware` was split into separate vendor-specific packages we need to start with removing the old one (`Rdd` to not check dependencies): `sudo pacman -Rdd linux-firmware`
1. Install new `linux-firmware` meta-package: `sudo pacman -Sy linux-firmware`
1. Since this is a fresh boot, upgrade all packages: `sudo pacman -Syu`
1. Install git and ansible: `sudo pacman -S git ansible`
1. Clone dotfiles repo: `git clone https://github.com/znibb/dotfiles .dotfiles`
1. Enter dotfiles directory and install required ansible collections: `cd .dotfiles && ansible-galaxy install -r requirements.yml`
1. Run the appropriate playbook: `ansible-playbook -i inventory/hosts.yml <playbook>`
1. Start `Alacritty` and start a `tmux` session: `tmux new-session -s main`
1. Install `tmux` plugins by pressing <Ctrl+a> followed by `I` (capital `i`)
1. Update `tmux` plugins by pressing <Ctrl+a> followed by `U` (capital `u`) and then typing `all` and pressing <Enter>
1. Reboot the system: `sudo reboot`

#### Theming
##### GRUB
1. Install `grub-customizer`: `sudo pacman -S grub-customizer`
1. Open `grub-customizer`, go to `General settings` tab and uncheck `look for other operating systems` and lower the  `Boot default entry after` count to `0`
1. Click `Save` and exit the program

##### SDDM
Go to `System Settings->Colors & Themes->Login Screen (SDDM)`, add `SilentSDDM` select it and `Apply`

##### KDE
1. Disable splash sceen by going to `System Settings->Colors & Themes->Global Theme->Splash Screen`, select `None` and press `Apply`
1. Set Plasma Style by going to `System Settings->Colors & Themes->Global Theme->Plasma Style`, adding `Nordic darker KDE`, select it and `Apply`
1. Enable clock seconds display by right-clicking the clock in the bottom right and selecting `Configure Digital Clock...`, then change `Show seconds` to `always` and click `OK`
1. Enable Icons-Only Task Manager by right-clicking on the bottom panel, selecting `Show Alternatives...` and clicking `Icons-Only Task Manager`
1. Disable task bar panel floating by right-clicking on the bottom panel and selecting `Show Panel Configuration`, then changing `Floating` to `Disabled` and pressing `Exit Edit Mode`

#### Cleanup
1. Remove default installed browser `falkon`: `sudo pacman -R falkon`
1. Remove `modemmanager`: `sudo pacman -Rdd modemmanager modemmanager-qt libmm-glib`
1. Go to `~/.ssh` and create an ssh key-pair for use with GitHub: `cd ~/.ssh && ssh-keygen -t ed25519 -C "USER@HOST" -f github-USERNAME`
1. Log into your GitHub account and add the public key to `Authentication keys`
1. Change the `dotfiles` repo remote url to allow pushing via ssh: `cd ~/.dotfiles && git remote set-url origin git@github.com:znibb/dotfiles.git`
1. Double-check that the `github.com` host is set up in `~/.ssh/config`: `cat ~/.ssh/config`

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
1. Enable swap on reboot by adding the following to `/etc/fstab`, `/swapfile none swap defaults 0 0`
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

### Locale overrides in Thunderbird
1. In Thunderbird go to `Settings->General`, scroll to the bottom and click `Config Editor`
1. Search for the override string name, select `String` and click `Add` (the plus sign to the right), enter the corresponding `Value` and click `Save`:

| String | Value | Example output |
| :----- | :---- | :------------- |
| intl.date_time.pattern_override.date_short | yyyy-MM-dd | 2025-12-31 |
| intl.date_time.pattern_override.time_short | HH:mm | 09:59 |

### Add search options in KRunner
1. Go to `System Settings->Plasma Search`, scroll down to `Web Search Keywords` and click `Configure...`
1. Create a new keyword:
   * ChatGPT
      - Name: `ChatGPT`
      - URL: `https://chatgpt.com/?model=gpt-4o&q=\{@}`
      - Keywords: `gpt`
   * ClaudeAI
      - Name: `Claude`
      - URL: `https://claude.ai/new?q=\{@}`
      - Keywords: `cl`
   * Digikey
      - Name: `Digikey`
      - URL: `https://www.digikey.se/en/products/result?keywords=\{@}`
      - Keywords: `dk`

### Install/update tmux plugins
Use `prefix` + `I` (capital i) to fetch new plugins or use `prefix` + `U` (capital u) to update installed plugins
