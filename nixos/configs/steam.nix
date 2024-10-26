{pkgs, ...}: {
    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
            mangohud
        ];
        protontricks.enable = true;
        };
    programs.gamemode.enable = true;
}