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

#### Post-install cleanup
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
1. Set keyboard language by going to `System Settings->Keyboard` and adding the preferred layout(s) to the list

#### Cleanup
1. Remove default installed browser `falkon`: `sudo pacman -R falkon`
1. Remove `modemmanager`: `sudo pacman -Rdd modemmanager modemmanager-qt libmm-glib`
1. Go to `~/.ssh` and create an ssh key-pair for use with GitHub: `cd ~/.ssh && ssh-keygen -t ed25519 -C "USER@HOST" -f github-USERNAME`
1. Log into your GitHub account and add the public key to `Authentication keys`
1. Change the `dotfiles` repo remote url to allow pushing via ssh: `cd ~/.dotfiles && git remote set-url origin git@github.com:znibb/dotfiles.git`
1. Double-check that the `github.com` host is set up in `~/.ssh/config`: `cat ~/.ssh/config`