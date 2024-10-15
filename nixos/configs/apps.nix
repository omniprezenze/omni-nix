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
            pkgs.bottles
            pkgs.telegram-desktop

            pkgs.python3
            pkgs.pipx
            pkgs.ansible
            pkgs.kubectl
            pkgs.terraform
        ];
    };
    # for python: nix-shell -p python3 --command "python -m venv .venv --copies"
    # activate and use the Python virtual environment as usual and install dependencies

    virtualisation.docker.enable = true;

    # steam and shit

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs;[
            proton-ge-bin
            mangohud
        ];
        gamescopeSession.enable = true;
    };
    # in launch opts
    # use gamemoderun %command%
    # use mangohud %command%
    # use gamescope %command%

    programs.gamemode.enable = true;

}