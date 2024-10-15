{ inputs, pkgs, ...}: {

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

  # Show asterisks when typing sudo password
  security.sudo.extraConfig = "Defaults env_reset,pwfeedback";

  powerManagement.cpuFreqGovernor = "performance";

  networking = {
    enableIPv6 = false;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        9443 # webui panel
        11434 # ollama
        5900 # vnc
      ];
    };
    wireless.iwd.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment = {
    systemPackages = with pkgs; [
      tcpdump
      impala
      vim
      atop
      lsof
      pwgen
      nil
      nomacs # basic image editor
      ripgrep # command-line search tool that recursively searches directories for regex patterns
      unrar
      unzip
      p7zip
      tree
      lm_sensors
      jq
      dig
      wget
      openssl
      smartmontools
      file
      patchelf
      zsh-powerlevel10k
    ];
    shells = [pkgs.zsh];
    variables = {
      EDITOR = "vim";
      XKB_DEFAULT_LAYOUT = "us,ru";
      XKB_DEFAULT_OPTIONS = "altwin:menu_win, grp:ctrl_space_toggle";
    };
    shellAliases = {
      kbc = "kubectl";
      ip = "ip --color";
      kssh = "kitten ssh";
      usb-mount = "udisksctl mount -b";
      usb-unmount = "udisksctl unmount -b";
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
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
          "fancy-ctrl-z"
          ];
        };
      };
    direnv.enable = true;
  };

  time.timeZone = "Europe/Warsaw";

  console = {
    font = "ter-124b";
    packages = with pkgs; [
      terminus_font
    ];
  };

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
        "wheel" "networkmanager" "input" "ydotool"
        "video" "gamemode" "corectrl"
      ];
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Uiua386"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      meslo-lgs-nf
    ];
  };

  nix = {
    settings = {
      allowed-users = ["@wheel"];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      warn-dirty = false;
      substituters = ["https://ezkea.cachix.org" "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
