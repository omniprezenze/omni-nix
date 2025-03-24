{ config, pkgs, ... }:

{
  systemd.user.services.hyprpaper = {
    description = "Fast, IPC-controlled wallpaper utility for Hyprland.";
    documentation = [ "https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/" ];
    partOf = [ "graphical-session.target" ];
    requires = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Slice = "session.slice";
      Restart = "on-failure";
    };
  };
}
