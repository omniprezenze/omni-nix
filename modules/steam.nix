{ config, pkgs, inputs, ... }:{
  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

  programs = {
    steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = with pkgs;[
          proton-ge-bin
      ];
      protontricks.enable = true;
      # gamescope -h 1440 -H 1440 -f -r 180 -e --force-grab-cursor --adaptive-sync -- %command% -steamos3
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    mangojuice
  ];

  hardware.xone.enable = true;

}
