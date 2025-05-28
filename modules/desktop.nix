{  inputs, pkgs, lib, config, ... }:
  let
    hyprlandUWSMWrapper = pkgs.writeShellScriptBin "Hyprland" ''
      set -eu

      HYPRLAND_BINARY="/run/current-system/sw/bin/hyprland"
      HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland_${config.networking.hostName}.conf"

      exec "$HYPRLAND_BINARY" -c "$HYPRLAND_CONFIG"
    '';
  in
  {
    environment = {
      systemPackages = with pkgs; [
        fastfetch
        btop

        vulkan-tools

        everforest-gtk-theme

        #iwgtk # wifi management
        winbox # routeros client
        xdg-utils
        selectdefaultapplication

        # terminal emulator
        ghostty
        
        sassc

        psmisc
        wl-clipboard
        wl-clip-persist
        xdg-utils

        # command control/automation
        # wtype
        # wlrctl
        dotool

        playerctl

        nwg-look
        bibata-cursors
        kdePackages.qt6ct

        hyprpicker
        hyprpaper
        wlogout
        waybar
        fuzzel
        swaynotificationcenter # notification center for sway
        wttrbar # weather information display
        hyprshot # screenshots
        hyprpolkitagent
        hyprland-qtutils
        #sway-audio-idle-inhibit

        pacvim
        
        calcure #calendar
        
        cava
        
        piper # frontend for ratbag (mouse settings)
        
        zathura # pdf reader
        mpv # media player
        imv # image viewer
        pinta # paint
        gnome-text-editor # notepad
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
      };
      shellAliases = {
        restart-sound   = "systemctl --user restart pipewire{,-pulse} wireplumber";
        hyprland-logout = "loginctl terminate-user \"\"";
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
      greetd = {
        enable = true;
        # settings.default_session = {
        #   user = "greeter";
        #   command = lib.strings.concatStringsSep " " [
        #     "${pkgs.greetd.tuigreet}/bin/tuigreet"
        #     "--time"
        #     "--remember"
        #     "--asterisks"
        #     "--user-menu"
        #     "--cmd \"/run/current-system/sw/bin/uwsm start -- hyprland-uwsm.desktop -c ~/.config/hypr/hyprland_${config.networking.hostName}.conf\""
        #   ];
        # };
      };
    };

    security.pam.services.hyprlock = {};

    programs = { 
      firefox.enable = true;
      appimage = {
        enable = true;
        binfmt = true;
      };
      direnv.enable = true;
      file-roller.enable = true;
      dconf.enable = true;
      xfconf.enable = true;
      thunar = {
        enable = true;
        plugins = [
            pkgs.xfce.thunar-archive-plugin
            pkgs.xfce.tumbler
            pkgs.xfce.thunar-volman
        ];
      };
      corectrl = {
        enable = true;
        gpuOverclock = { 
            enable = true;
        };
      };
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        xwayland.enable = true;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        xwayland.enable = true;
      };
      uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "${hyprlandUWSMWrapper}/bin/Hyprland";
          };
          sway = {
            prettyName = "Sway";
            comment = "Sway compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/sway";
          };
        };
      };
      hyprlock = {
        enable = true;
        package = pkgs.hyprlock;
      };
      regreet = {
        enable = true;
        theme.name = "Everforest-Dark-BL";
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
