# Dotfiles

## Arch
See [docs/arch.md](docs/arch.md)

## Artix
See [docs/artix.md](docs/artix.md)

## Alpine
See [docs/alpine.md](docs/alpine.md)

## Setting up dotfiles
1. Clone dotfiles repo: `git clone https://github.com/znibb/dotfiles .dotfiles`
1. Enter dotfiles directory and install required ansible collections: `cd .dotfiles && ansible-galaxy install -r requirements.yml`
1. Run the appropriate playbook: `ansible-playbook -i inventory/hosts.yml <playbook>`

To allow pushing to the repo:
1. Create an ssh key-pair by going go `~/.ssh` and running `ssh-keygen -t ed25519 -C "USER@HOST" -f github-USERNAME` and then log into your GitHub account and add the public key to `Authentication keys`.
1. Change the repo remote: `git remote set-url origin git@github.com:znibb/dotfiles` (requires key to be set up in `~/.ssh/config`)


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

### Role boilerplate
#### Pacman install
```
- name: Install pacman packages
  become: true
  community.general.pacman:
    update_cache: false
    name:
        - package
    state: present
  register: pkg_output

- name: Show installed packages
  ansible.builtin.debug:
    msg: "{{ ['Installed packages:'] + pkg_output.packages }}"
  when: pkg_output.changed
```

#### AUR install
```
- name: Install AUR packages
  kewlfft.aur.aur:
    use: "{{ aur_helper }}"
    update_cache: false
    name:
      - package
    state: present
  register: pkg_output

- name: Show installed packages
    ansible.builtin.debug:
      msg: "{{ ['Installed packages:'] + pkg_output.installed }}"
    when: pkg_output.changed
```

#### Apk install
```
- name: Install packages
  become: true
  community.general.apk:
    update_cache: false
    name:
      - package
    state: present
  register: pkg_output
```

#### Main
```
- name: Arch/Artix
  ansible.builtin.include_tasks: "arch.yml"
  when: ansible_distribution | lower == 'archlinux' or ansible_distribution | lower == 'artix linux'

- name: Alpine
  ansible.builtin.include_tasks: "alpine.yml"
  when: ansible_distribution | lower == 'alpine'
```

### Setting up swap
#### Swapfile
1. Create file to use as swap, `sudo fallocate -l 30G /swapfile`
1. Set proper permissions, `sudo chmod 600 /swapfile`
1. Format file to be used as swap, `sudo mkswap /swapfile`
1. Enable swap, `sudo swapon /swapfile`
1. Enable swap on reboot by adding the following to `/etc/fstab`, `/swapfile none swap defaults 0 0`

#### Hibernate to swapfile
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

### Set up directory sharing with virt-manager
#### Host actions
1. Make sure the intended target VM is turned off
1. Create a host source directory, e.g.: `mkdir ~/vm-share`
1. Set liberal file permissions (in case VM user doesn't map well to the host user): `chmod 777 ~/vm-share`
1. Open `virt-manager`, open the intended target VM and click `View->Details`
1. Go to `Memory` and make sure `Enable shared memory` is checked
1. Click the `Add Hardware` button in the bottom left
1. Select `Filesystem` and enter:
- Driver: `virtiofs`
- Source path: Full path to the directory created above (can also use `Browse...` to find it)
- Target path: `share` (not actually a path but a label)
1. Click `Finish` and then `Apply`
1. Start the VM

#### VM actions
1. Create a target directory, e.g.: `~/vm-share`
1. Mount the host directory into the VM: `sudo mount -t virtiofs share /home/<user>/vm-share`  

The `~/vm-share` directory is now shared between the host and VM.  

To make the shared directory auto mount on boot make the following addition to `/etc/fstab`: `share /home/<user>/vm-share virtiofs defaults 0 0`