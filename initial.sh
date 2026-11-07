#! /run/current-system/sw/bin/bash

set -euo pipefail

#prereq nix-shell -p git

config_file="/mnt/etc/nixos/configuration.nix"
main_disk="${1:?Usage: initial.sh /dev/disk}"
main_disk="$(readlink -f -- "$main_disk")"

if [[ ! -b "$main_disk" ]]; then
    echo "Not a block device: $main_disk" >&2
    exit 1
fi
if [[ "$(lsblk -dn -o TYPE "$main_disk")" != "disk" ]]; then
    echo "Not a whole disk: $main_disk" >&2
    exit 1
fi
if [[ ! -b /dev/disk/by-label/home ]]; then
    echo "A separate filesystem labelled home must already exist" >&2
    exit 1
fi

read -r -p "This will erase $main_disk. Type ERASE to continue: " confirmation
if [[ "$confirmation" != "ERASE" ]]; then
    exit 1
fi

partition_separator=""
if [[ "$main_disk" =~ [0-9]$ ]]; then
    partition_separator="p"
fi
root_partition="${main_disk}${partition_separator}1"
swap_partition="${main_disk}${partition_separator}2"
boot_partition="${main_disk}${partition_separator}3"

parted "$main_disk" -- mklabel gpt
parted "$main_disk" -- mkpart ROOT ext4 1G -8GB
parted "$main_disk" -- mkpart SWAP linux-swap -8GB 95%
parted "$main_disk" -- mkpart BOOT fat32 1MB 1G
parted "$main_disk" -- set 3 esp on
udevadm settle

mkfs.ext4 -L ROOT "$root_partition"
mkswap -L SWAP "$swap_partition"
mkfs.fat -F 32 -n BOOT "$boot_partition"

mount "$root_partition" /mnt
mkdir -p /mnt/boot
mount -o umask=077 "$boot_partition" /mnt/boot
swapon "$swap_partition"

# assuming you've created the lvm bozo
mkdir -p /mnt/home
mount /dev/disk/by-label/home /mnt/home

nixos-generate-config --root /mnt

sed -i '/xserver.enable/a\
    users = { users.omni = { isNormalUser = true; home = "/home/omni"; extraGroups = ["wheel"]; }; };\
    nix = { settings = { experimental-features = ["nix-command" "flakes"]; warn-dirty = false; }; gc = { automatic = true; dates = "daily"; options = "--delete-older-than 7d"; }; };\
    networking.hostName = "omnipc";\
    networking = { networkmanager.enable = true; };\
    nixpkgs = { config.allowUnfree = true; };\
    time.timeZone = "Europe/Warsaw";\
    i18n.defaultLocale = "en_IE.UTF-8";\
    programs = { git.enable = true; };\
    environment = { systemPackages = [ pkgs.vim ]; };' "$config_file"

echo "change hardware conf to labels"
echo "then cd /mnt and nixos-install"
echo "then nixos-enter --root /mnt -c 'passwd omni'"