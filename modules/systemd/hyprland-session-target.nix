{ config, pkgs, ... }:

{
  systemd.user.targets.hyprland-session = {
    name = "hyprland-session.target";
    description = "Hyprland Session Target";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    unitConfig.PropagatesStopTo = "graphical-session.target";
  };
}
