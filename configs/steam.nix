{ config, pkgs, ... }:

{
    programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
        ];
        remotePlay.openFirewall = true; # Steam Remote Play.
        dedicatedServer.openFirewall = true; # Source Dedicated Server.
        gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
        mangohud
    ];
}