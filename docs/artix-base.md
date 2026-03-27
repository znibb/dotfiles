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
1. Format the intended EFI system partition as fat32: `mkfs.fat -F 32 -n ESP /dev/xxx1`
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