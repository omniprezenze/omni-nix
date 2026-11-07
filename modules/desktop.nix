{  inputs, pkgs, lib, config, ... }:
  let
    hyprland-session = pkgs.writeShellScript "hyprland-session" ''
      trap '${pkgs.systemd}/bin/systemctl --user stop hyprland-session.target graphical-session.target' EXIT
      /run/current-system/sw/bin/start-hyprland
    '';
  in {
    environment = {
      etc = lib.mkIf (config.networking.hostName == "omnipc") {
        "tuigreet/config.toml".source = ../dotfiles/tuigreet/config.toml;
      };
      systemPackages = with pkgs; [
        fastfetch
        btop

        vulkan-tools

        winbox # routeros client
        xdg-utils
        selectdefaultapplication
        
        ghostty
        
        psmisc

        wl-clipboard
        wl-clip-persist
        xdg-utils

        file-roller

        dotool
        google-chrome
        busybox
        dfu-util

        playerctl

        nwg-look
        bibata-cursors
        kdePackages.qt6ct

        hyprpolkitagent
        wlogout

        grim
        slurp
        libnotify

        xrandr

        proton-vpn

        pacvim
                
        piper # frontend for ratbag (mouse settings)
        
        zathura # pdf reader
        mpv # media player
        imv # image viewer
        pinta # paint
        gnome-text-editor # notepad
        
        ashell
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # for electron and chromium apps to run on wayland
        MOZ_ENABLE_WAYLAND = "1"; # firefox should always run on wayland

        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GTK_USE_PORTAL = "1"; # makes dialogs (file opening) consistent with rest of the ui
        XDG_SESSION_TYPE = "wayland";
        HYPRLAND_LOG_WLR = 1;
        XCURSOR_SIZE = 24;
        XCURSOR_THEME = "Bibata-Modern-Classic";
        HYPRCURSOR_SIZE = 24;
        HYPRCURSOR_THEME = "Bibata-Modern-Classic";
        TERMINAL = "ghostty";
        QT_QPA_PLATFORMTHEME = "qt6ct";

        WAYLANDDRV_PRIMARY_MONITOR = "DP-1";
      };
      shellAliases = {
        hdrmpv = "ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk";
      };
    };

    networking.firewall.checkReversePath = false;

    services = {
      dbus = {
        enable = true;
        implementation = "broker";
      };
      mpd.enable = true;
      udisks2.enable = true;
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # thunar Thumbnail support for images
      ratbagd.enable = true;
      hypridle.enable = true;
      greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session = {
          user = "greeter";
          command = lib.strings.concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--asterisks"
            "--cmd ${hyprland-session}"
#            "--cmd 'start-hyprland-custom'"
          ];
        };
      };
    };

    programs = { 
      firefox.enable = true;
      appimage = {
        enable = true;
        binfmt = true;
      };
      direnv.enable = true;
      dconf.enable = true;
      xfconf.enable = true;
      thunar = {
        enable = true;
        plugins = [
          pkgs.thunar-archive-plugin
          pkgs.tumbler
          pkgs.thunar-volman
        ];
      };
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      dux-shell = {
        enable = true;
        package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };
  }
