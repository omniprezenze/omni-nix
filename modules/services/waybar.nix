{ config, pkgs, ... }:

{
  systemd.user.services.waybar = {
    description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
    documentation = [ "https://github.com/Alexays/Waybar/wiki/" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    path = [ "/run/current-system/sw" ];

    serviceConfig = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
    };
  };
}
