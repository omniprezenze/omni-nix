{pkgs, ...}: {  
    environment = {
        systemPackages = [
            pkgs.gimp
            pkgs.helvum
            pkgs.qpwgraph
            pkgs.lutris
            pkgs.obs-studio
            pkgs.path-of-building
            pkgs.qbittorrent
            pkgs.discord
            pkgs.wine64

            pkgs.python3
            pkgs.ansible
            pkgs.kubectl
            pkgs.terraform
        ];
    }

    virtualisation.docker.enable = true;

    # games shit

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
        ]; 
    };

    programs.gamemode.enable = true;

    # amd gpu drivers
    hardware.opengl = {
        ## radv: an open-source Vulkan driver from freedesktop
        driSupport = true;
        driSupport32Bit = true;

        ## amdvlk: an open-source Vulkan driver from AMD
        extraPackages = [ pkgs.amdvlk ];
        extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

}