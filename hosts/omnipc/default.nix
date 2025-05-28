{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/amd-gpu.nix
    ../../modules/sound.nix
    ../../modules/bluetooth.nix
    ../../modules/apps.nix
    ../../modules/virtualisation.nix
    ../../modules/steam.nix
#    ../../modules/aagl.nix
  ];

  system.stateVersion = "24.05";
  networking.hostName = "omnipc";
  services.fstrim.enable = true; # ssd trimming

}
