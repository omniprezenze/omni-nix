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

      rusty-path-of-building

      antigravity

      vesktop
      telegram-desktop
      spotify
      vscodium
      obsidian
      qalculate-gtk
      shotcut

      lshw-gui

      pcsx2
      gearlever
      ryubing
      wowup-cf
      #rpcs3

      goverlay

      protonplus
      winetricks
      wineWowPackages.stagingFull
      (bottles.override { removeWarningPopup = true; })
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
