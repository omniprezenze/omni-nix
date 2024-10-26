{pkgs, ...}: {
    environment = {
        systemPackages = [
            pkgs.gimp
            pkgs.lutris
            pkgs.obs-studio
            pkgs.path-of-building
            pkgs.qbittorrent
            pkgs.vesktop
            pkgs.wine64
            pkgs.bottles
            pkgs.telegram-desktop
            pkgs.spotify
            pkgs.vscode
            pkgs.xdotool

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

}
