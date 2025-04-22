{ config, pkgs, ... }:

{
  systemd.user.services.hyprpaper-c = {
    description = "Fast, IPC-controlled wallpaper utility for Hyprland.";
    documentation = [ "https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/" ];
    partOf = [ "graphical-session.target" ];
    requires = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/hyprpaper";
      Slice = "session.slice";
      Restart = "on-failure";
    };
  };
}
