{pkgs, inputs, ...}: {
  system.stateVersion = "24.05";

  boot = {
    initrd = {
      systemd.enable = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    tmp.cleanOnBoot = true;
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "omnipc";
  networking = {
    networkmanager.enable = true;
  };
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
      Scan = {
        DisablePeriodicScan = true;
      };
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment = {
    systemPackages = with pkgs; [
      impala
      vim
      fastfetch
      btop
      firefox
      kitty # terminal emulator 
      nil
      nomacs # basic image editor
      ripgrep # command-line search tool that recursively searches directories for regex patterns
      unrar
      unzip
      vulkan-tools
      helvum
      qpwgraph
      tree
      lm_sensors
      jq
      dig
    ];
  };

  environment = {
    shells = [pkgs.zsh];
    variables = {
      EDITOR = "vim";
      XKB_DEFAULT_LAYOUT = "us,ru";
      XKB_DEFAULT_OPTIONS = "altwin:menu_win, grp:ctrl_space_toggle";
    };
  };

  services.udisks2.enable = true;

  programs = {
    git.enable = true;
    ssh.startAgent = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      autosuggestions.strategy = ["completion"];
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "direnv"
          "fancy-ctrl-z"
          ];
        };
      };
    direnv.enable = true;
  };

  time.timeZone = "Europe/Warsaw";

  # console = {
  #   font = "Lat2-Terminus16";
  # };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "en_IE.UTF-8/UTF-8"
  ];
  
  i18n.defaultLocale = "en_IE.UTF-8";

  users = {
    defaultUserShell = pkgs.zsh;
    users.omni = {
      isNormalUser = true;
      home = "/home/omni";
      extraGroups = [
        "wheel" "networkmanager" "docker" 
        "video" "gamemode" "corectrl" "input" "ydotool"
      ];
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["Fira Code" "MesloLGS NF" "Noto Color Emoji"];
        emoji = ["Noto Sans" "Noto Color Emoji"];
      };
    };
    packages = [
      pkgs.dejavu_fonts
      pkgs.fira-code
      pkgs.meslo-lgs-nf
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-emoji
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      substituters = ["https://ezkea.cachix.org" ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
