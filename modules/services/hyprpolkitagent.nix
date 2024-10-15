{ config, pkgs, ... }:
{
  systemd.user.services.hyprpolkitagent-c = {
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    description = "Hyprland Polkit Authentication Agent";

    serviceConfig = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Slice = "session.slice";
      Restart = "on-failure";
      RestartSec = "5sec";
    };
  };
}
