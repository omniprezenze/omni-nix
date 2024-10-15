#! /run/current-system/sw/bin/bash

#prereq nix-shell -p git

config_file="/mnt/etc/nixos/configuration.nix"
main_disk="/dev/sda"
home_disk="/dev/sdb"

parted $main_disk -- mklabel gpt
parted $main_disk -- mkpart root ext4 1G -8GB
parted $main_disk -- mkpart swap linux-swap -8GB 95%
parted $main_disk -- mkpart ESP fat32 1MB 1G
parted $main_disk -- set 3 esp on

mkfs.ext4 -L nixos ${main_disk}1
mkswap -L swap ${main_disk}2
mkfs.fat -F 32 -n boot ${main_disk}3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

pvcreate $home_disk
vgcreate user-vg $home_disk
lvcreate -L 3000G -n home-lv user-vg
mkfs.ext4 -L home /dev/user-vg/home-lv
mkdir -p /mnt/home
sleep 3
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
echo "then nixos-enter --root /mnt -c 'passwd alice'"