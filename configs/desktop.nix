{ pkgs, lib, ... }: {
  
  # Enable Hyprland
  programs = {
    hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
    };
  };
  
  environment.sessionVariables = {
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

  environment = {
    systemPackages = with pkgs; [
      
      hyprpaper # wallpaper daemon
      hypridle

      iwgtk

      starship

      playerctl
      psmisc
      grim
      slurp
      swappy
      wl-clipboard
      wl-clip-persist
      xdg-utils
      wtype
      wlrctl
      waybar

      wttrbar # weather information display

      nwg-look
      glib
      gsettings-desktop-schemas
      bibata-cursors

      rofi-wayland
      swaynotificationcenter # notification center for sway
      wlogout
      amdgpu_top
      piper

      firefox
      zathura
      mpv
      imv
      hiddify-app
      kdePackages.kdenlive
    ];
  };

  services.hypridle.enable = true;

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };
  security.pam.services.hyprlock = {};

  # Enable Display Manager
  services.greetd = {
    enable = true;

    settings.default_session = {
      user = "greeter";

      command = lib.strings.concatStringsSep " " [
        "${pkgs.greetd.tuigreet}/bin/tuigreet"
        "--time"
        "--remember"
        "--asterisks"
        "--user-menu"
        "--theme \"border=magenta;text=cyan;prompt=red;time=white;action=blue;button=green;container=black;input=white\""
        "--cmd \"${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop\""
      ];
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

  # Enable Services
  programs.direnv.enable = true;
  programs.file-roller.enable = true;
  programs.dconf.enable = true;
  services.ratbagd.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    # packages = with pkgs; [
    #   xfce.xfconf
    #   gnome2.GConf
    # ];
  };
  services.mpd.enable = true;
  programs.thunar = {
    enable = true;
    plugins = [
        pkgs.xfce.thunar-archive-plugin
    ];
  };
  programs.xfconf.enable = true;
  services.tumbler.enable = true; 

  programs.corectrl = {
    enable = true;
    gpuOverclock = { 
        enable = true;
    };
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
