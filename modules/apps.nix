{pkgs, ...}: {
  environment = with pkgs; {
    systemPackages = [
      keepassxc
      rclone
      gimp
      lutris
      obs-studio
      path-of-building
      qbittorrent
      vesktop
      wine64
      bottles
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
      rpcs3

      # for python: nix-shell -p python3 --command "python -m venv .venv --copies"
      # activate and use the Python virtual environment as usual and install dependencies
      python3
      pipx

      go
      gotools

      ansible
      kubectl
      terraform
    ];
    shellAliases = {
      kbc = "kubectl";
    };
  };
}
