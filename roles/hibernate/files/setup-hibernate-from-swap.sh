#!/bin/bash

set -e

SWAPFILE="${1:-/swapfile}"
GRUB_CONFIG="/etc/default/grub"
MKINITCPIO_CONF="/etc/mkinitcpio.conf"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if [[ ! -f "$SWAPFILE" ]]; then
    echo "Swapfile not found: $SWAPFILE"
    exit 1
fi

# Get root partition UUID
ROOT_UUID=$(findmnt -n -o UUID /)
if [[ -z "$ROOT_UUID" ]]; then
    echo "Could not determine root partition UUID"
    exit 1
fi

# Get swapfile physical offset
SWAP_OFFSET=$(filefrag -v "$SWAPFILE" | awk 'NR==4{print $4}' | tr -d '.')
if [[ -z "$SWAP_OFFSET" ]]; then
    echo "Could not determine swapfile offset"
    exit 1
fi

echo "Root UUID:     $ROOT_UUID"
echo "Swap offset:   $SWAP_OFFSET"
echo "Swapfile:      $SWAPFILE"

RESUME_PARAMS="resume=UUID=$ROOT_UUID resume_offset=$SWAP_OFFSET"

# Check if resume params already present
if grep -q "resume=UUID=" "$GRUB_CONFIG"; then
    echo "Updating existing resume parameters in $GRUB_CONFIG"
    sed -i "s|resume=UUID=[^ \"]*||g; s|resume_offset=[^ \"]*||g" "$GRUB_CONFIG"
    sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $RESUME_PARAMS\"|" "$GRUB_CONFIG"
else
    echo "Adding resume parameters to $GRUB_CONFIG"
    sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $RESUME_PARAMS\"|" "$GRUB_CONFIG"
fi

# Clean up any double spaces introduced
sed -i 's|"  *|"|g; s|  *"$|"|' "$GRUB_CONFIG"

echo "Regenerating GRUB config..."
grub-mkconfig -o /boot/grub/grub.cfg

# Add resume hook to mkinitcpio if not already present
if grep -qE '^HOOKS=.*\bresume\b' "$MKINITCPIO_CONF"; then
    echo "resume hook already present in $MKINITCPIO_CONF"
else
    echo "Adding resume hook to $MKINITCPIO_CONF..."
    sed -i 's|\(HOOKS=([^)]*\bblock\b\)|\1 resume|' "$MKINITCPIO_CONF"
    if ! grep -qE '^HOOKS=.*\bresume\b' "$MKINITCPIO_CONF"; then
        echo "ERROR: Could not add resume hook. Add 'resume' after 'block' in $MKINITCPIO_CONF manually."
        exit 1
    fi
fi

echo "Rebuilding initramfs..."
mkinitcpio -P

echo "Done. Hibernate should work after reboot."
