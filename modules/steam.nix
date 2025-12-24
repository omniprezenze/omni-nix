{ inputs, pkgs, config, ... }:{
  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

  programs = {
    steam = {
      enable = true;
      platformOptimizations.enable = true;
      protontricks.enable = true;
      # can do PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 %command%
      # gamescope -h 1440 -H 1440 -f -r 180 -e --force-grab-cursor --adaptive-sync -- %command% -steamos3
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    evtest
  ];

  #hardware.xone.enable = true;
  # dualshock touchpad fix
  services.udev.extraRules = ''
    # Disable DS4 touchpad acting as mouse
    # USB
    ATTRS{name}=="Sony Computer Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # Bluetooth
    ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

}
