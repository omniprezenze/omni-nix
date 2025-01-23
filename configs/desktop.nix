{ pkgs, lib, ... }: {
    
  environment = {
    systemPackages = with pkgs; [
      
      hyprpaper # wallpaper daemon
      
      iwgtk # wifi management

      psmisc
      grim
      slurp
      swappy
      wl-clipboard
      wl-clip-persist
      xdg-utils
      wtype
      wlrctl

      playerctl

      nwg-look
      glib
      gsettings-desktop-schemas
      bibata-cursors

      wlogout
      waybar
      rofi-wayland
      swaynotificationcenter # notification center for sway
      wttrbar # weather information display
      
      amdgpu_top
      piper # frontend for ratbag (mouse settings)
      firefox
      zathura # pdf reader
      mpv # media player
      imv # image viewer
      hiddify-app # vpn
      kdePackages.kdenlive #video editor
    ];
    sessionVariables = {
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";

      NIXOS_OZONE_WL = "1"; # for electron and chromium apps to run on wayland
      MOZ_ENABLE_WAYLAND = "1"; # firefox should always run on wayland

      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      GTK_USE_PORTAL = "1"; # makes dialogs (file opening) consistent with rest of the ui
      XDG_SESSION_TYPE = "wayland";
      HYPRLAND_LOG_WLR = 1;
      XCURSOR_SIZE = 24;
      HYPRCURSOR_SIZE = 24;
    };
  };

  services = {
    dbus = {
      enable = true;
      implementation = "broker";
    };
    mpd.enable = true;
    tumbler.enable = true;
    hypridle.enable = true;
    ratbagd.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        user = "greeter";
        command = lib.strings.concatStringsSep " " [
          "${pkgs.greetd.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--asterisks"
          "--user-menu"
          "--cmd \"${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop\""
        ];
      };
    };
  };

  security.pam.services.hyprlock = {};

  programs = { 
    direnv.enable = true;
    file-roller.enable = true;
    dconf.enable = true;
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = [
          pkgs.xfce.thunar-archive-plugin
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
      xwayland.enable = true;
      withUWSM = true;
    };
    hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      xdgOpenUsePortal = true;
  };

}
