{inputs, pkgs, ...}: {
  nixpkgs.overlays = [inputs.oskars-dotfiles.overlays.spotx];
  environment = with pkgs; {
    systemPackages = [
      keepassxc
      rclone
      gimp3
      obs-studio
      path-of-building
      qbittorrent
      
      wayvnc

      vesktop
      telegram-desktop
      spotify
      vscodium
      obsidian
      qalculate-gtk
      shotcut
      hiddify-app

      pcsx2
      duckstation
      ryujinx-greemdev
      #rpcs3

      protonplus
      winetricks
      (lutris.override {
        extraPkgs = pkgs: [
          umu-launcher
          wineWowPackages.waylandFull
        ];
      })
      # for python: nix-shell -p python3 --command "python -m venv .venv --copies"
      # activate and use the Python virtual environment as usual and install dependencies
      (python313.withPackages (ps:
        with ps; [
          flask
          pandas
          requests
          pyquery
          pyyaml
          tenacity
        ]
      ))
      pipx

      go
      gotools

      ansible
      kubectl
      kubernetes-helm
      kubecm
      terraform
      linode-cli
    ];
    shellAliases = {
      kbc = "kubectl";
    };
  };
}
