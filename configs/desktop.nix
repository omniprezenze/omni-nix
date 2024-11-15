{ pkgs, ... }: {
  
  # Enable Hyprland
  programs = {
    hyprland = {
        enable = true;
        xwayland.enable = true;
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
      glib
      gsettings-desktop-schemas
      theme-obsidian2
      bibata-cursors

      rofi-wayland
      swaynotificationcenter # notification center for sway
      wlogout
      amdgpu_top

      firefox
      zathura
      mpv
      imv
    ];
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
  };
  security.pam.services.hyprlock = {};

  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --user-menu --theme 'border=blue;text=cyan;prompt=green;time=red;action=blue;button=white;container=black;input=red' --cmd Hyprland";
        user = "greeter";
      };
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
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [
      xfce.xfconf
      gnome2.GConf
    ];
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
      extraPortals = [
          pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
  };

}
