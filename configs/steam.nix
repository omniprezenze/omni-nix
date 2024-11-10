{ config, pkgs, ... }:

{
    hardware.xone.enable = true;
    
    programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
        ];
        remotePlay.openFirewall = true; # Steam Remote Play.
        dedicatedServer.openFirewall = true; # Source Dedicated Server.
        # gamescope -w 3840 -h 2160 -W 2560 -H 2560 -f -F fsr -r 144 -e -- %command% 
        # LD_PRELOAD="" gamescope -w 3840 -h 2160 -W 2560 -H 2560 -f -F fsr -r 144 -e -- %command% 
        gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
        mangohud
    ];
}