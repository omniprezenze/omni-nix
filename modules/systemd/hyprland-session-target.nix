{ config, pkgs, ... }:

{
  systemd.user.targets.hyprland-session = {
    name = "hyprland-session.target";
    description = "Hyprland Session Target";
    requires = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };
}
