{inputs, pkgs, ...}: {
  environment = with pkgs; {
    systemPackages = [
      keepassxc
      rclone
      gimp3
      obs-studio
      qbittorrent
      
      wayvnc
      wireshark

      path-of-building

      vesktop
      telegram-desktop
      spotify
      vscodium
      obsidian
      qalculate-gtk
      shotcut
      #hiddify-app

      pcsx2
      gearlever
      ryujinx-greemdev
      wowup-cf
      #rpcs3

      protonplus
      winetricks
      bottles
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
  #services.flatpak.enable = true;
}
