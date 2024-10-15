{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/apps.nix
    ../../modules/steam.nix
    ../../modules/aagl.nix
    ../../modules/sound.nix
    ../../modules/nvidia.nix
    ../../modules/bluetooth.nix
    ../../modules/virtualisation.nix
  ];

  system.stateVersion = "24.05";
  networking.hostName = "omnilaptop";
}
