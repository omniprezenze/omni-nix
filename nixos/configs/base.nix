{pkgs, inputs, ...}: {

    system.stateVersion = "24.11";

    imports = [
        ./hardware-configuration.nix
        ./amd-gpu.nix
        ./bluetooth.nix
        ./apps.nix
        ./steam.nix
        ../../packages/scripts/screenshot.nix
        ./kb_bluetooth.nix
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.nix-gaming.nixosModules.pipewireLowLatency
    ];
    
    boot = {
        initrd.kernelModules = [ "amdgpu" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
        loader = {
            systemd-boot = {
                enable = true;
                editor = false;
                configurationLimit = 5;
            };
            timeout = 15;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
        };
    };

    hardware.xone.enable = true;
    networking.hostName = "omnipc";

    networking = {
        networkmanager.enable = true;
    };

    nixpkgs = {
        config.allowUnfree = true;
    };

    environment = {
        systemPackages = [
            pkgs.vim
            pkgs.bemoji
            pkgs.bibata-cursors
            pkgs.btop
            pkgs.eza # modern replacement for the ls
            pkgs.diff-so-fancy 
            pkgs.firefox
            pkgs.fuzzel # app launcher
            pkgs.fzf # fuzzy finder 
            pkgs.hyprpaper # wallpaper manager 
            pkgs.kdiff3 # graphical tool for comparing and merging files and directories
            pkgs.kitty # terminal emulator 
            pkgs.meld # visual diff and merge tool 
            pkgs.nil
            pkgs.nomacs # basic image editor
            pkgs.pavucontrol # graphical PulseAudio volume control tool 
            pkgs.polkit_gnome
            pkgs.playerctl # control media players 
            pkgs.ripgrep # command-line search tool that recursively searches directories for regex patterns
            pkgs.sd # sed replacer
            pkgs.swaylock-effects # screen locker for sway
            pkgs.swaynotificationcenter # notification center for sway
            pkgs.tldr # simple man
            pkgs.udiskie # removable disks daemon 
            pkgs.unrar
            pkgs.unzip
            pkgs.vlc
            pkgs.waybar # WM top bar
            pkgs.wlogout # logout dialog 
            pkgs.wl-clipboard
            pkgs.wl-clip-persist
            pkgs.wttrbar # weather information display
            pkgs.glib
            pkgs.gsettings-desktop-schemas
            pkgs.dconf
            pkgs.theme-obsidian2
            pkgs.xdg-user-dirs
            pkgs.xdg-utils
            pkgs.zoxide # cd replace with fuzzy search
            pkgs.amdgpu_top
            pkgs.vulkan-tools
            pkgs.helvum
            pkgs.qpwgraph
            pkgs.tree
            pkgs.lm_sensors
        ];
    };

    services = {
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            lowLatency.enable = true;
        };
        greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --user-menu --cmd Hyprland";
                    user = "greeter";
                };
            };
        };
        udisks2.enable = true;
    };

    security = { 
        pam.services.swaylock.text = "auth include login";
        rtkit.enable = true;
    };
    
    environment = {
        shells = [pkgs.zsh];
        sessionVariables = {
            NIXOS_OZONE_WL = "1";
            GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
            };
        variables = {
            EDITOR = "vim";
            BEMOJI_PICKER_CMD = "fuzzel --dmenu";
        };
    };

    programs = {
        file-roller.enable = true;
        git.enable = true;
        corectrl = {
            enable = true;
            gpuOverclock = { 
                enable = true;
                ppfeaturemask = "0xffffffff";
            };
        };
        hyprland = {
            enable = true;
            xwayland.enable = true;
        };
        starship.enable = true;
        thunar = {
            enable = true;
            plugins = [
                pkgs.xfce.thunar-archive-plugin
                pkgs.xfce.tumbler
            ];
        };
        ssh.startAgent = true;
        zsh = {
            enable = true;
            autosuggestions.enable = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
            ohMyZsh = {
                enable = true;
                plugins = [
                    "direnv"
                    "fancy-ctrl-z"
                    "git"
                    "man"
                ];
            };
        };
        direnv.enable = true;
    };

    time.timeZone = "Europe/Warsaw";

    i18n.defaultLocale = "en_IE.UTF-8";
    console = {
        font = "Lat2-Terminus16";
    };

    users = {
        defaultUserShell = pkgs.zsh;
        users.omni = {
            isNormalUser = true;
            home = "/home/omni";
            extraGroups = ["wheel" "networkmanager" "video" "docker" "gamemode" "corectrl"];
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

    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-hyprland
        ];
        xdgOpenUsePortal = true;
    };

    nix = {
        settings = {
            experimental-features = ["nix-command" "flakes"];
            warn-dirty = false;
            substituters = ["https://nix-gaming.cachix.org"];
            trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
        };
        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
        };
    };
}
