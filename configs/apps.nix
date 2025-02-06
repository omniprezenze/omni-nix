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

      pcsx2
      duckstation
      ryujinx-greemdev
      rpcs3

      python3
      go
      gotools

      pipx
      ansible
      kubectl
      terraform
    ];
  };
  # for python: nix-shell -p python3 --command "python -m venv .venv --copies"
  # activate and use the Python virtual environment as usual and install dependencies

  virtualisation.docker.enable = true;
  services = { 
    ollama = {
      enable = true;
      acceleration = "rocm";
      openFirewall = true;
      rocmOverrideGfx = "11.0.0";
      loadModels = [ "deepseek-r1:32b" ];
      host = "0.0.0.0";
    };
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 9443;
    };
  };

}
