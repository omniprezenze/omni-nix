{  inputs, pkgs, lib, config, ... }:
  {
    environment = {
      systemPackages = with pkgs; [
        fastfetch
        btop

        vulkan-tools

        everforest-gtk-theme

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

        playerctl

        nwg-look
        bibata-cursors
        kdePackages.qt6ct

        hyprpolkitagent
        wlogout

        fuzzel

        grim
        slurp
        libnotify

        xorg.xrandr

        pacvim
        brave
        
        #calcure
                
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
        HYPRCURSOR_SIZE = 24;
        HYPRCURSOR_THEME = "Bibata-Modern-Ice";
        TERMINAL = "ghostty";
        QT_QPA_PLATFORMTHEME = "qt6ct";

        WAYLANDDRV_PRIMARY_MONITOR = "DP-1";
      };
      shellAliases = {
        hdrmpv = "ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk";
      };
    };

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
        settings.default_session = {
          user = "greeter";
          command = lib.strings.concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--asterisks"
            "--cmd 'start-hyprland-custom'"
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
      corectrl = {
        enable = true;
      };
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      dms-shell = {
        enable = true;
        enableDynamicTheming = false;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };
    };

    # Without these bootlogs will spam on screen
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
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
