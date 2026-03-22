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
1. Boot
1. ???
1. Profit?

### Artix install
#### Base install
See [docs/artix-base.md](artix-base.md)

#### Plasma install
See [docs/artix-plasma.md](artix-plasma.md)