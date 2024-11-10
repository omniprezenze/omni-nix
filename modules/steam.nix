{ config, pkgs, ... }:{

    
    programs = {
        gamescope = {
            enable = true;
            capSysNice = true;
            args = [
                "--rt"
                "--expose-wayland"
            ];
        };
        
        steam = {
            enable = true;
            extraCompatPackages = with pkgs;[
                proton-ge-bin
            ];
            protontricks.enable = true;
            remotePlay.openFirewall = true; # Steam Remote Play.
            dedicatedServer.openFirewall = true; # Source Dedicated Server.
            # gamescope -w 3840 -h 2160 -W 2560 -H 2560 -f -F fsr -r 144 -e -- %command% 
            gamescopeSession.enable = true;
        };
        gamemode.enable = true;
    };

    environment.systemPackages = with pkgs; [
        mangohud
    ];

    hardware.xone.enable = true;

}