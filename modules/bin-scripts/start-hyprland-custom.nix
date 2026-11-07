{ pkgs, ... }:
let
  start-hyprland-custom = pkgs.writeShellScriptBin "start-hyprland-custom" ''
    exec /run/current-system/sw/bin/start-hyprland "$@"
  '';
in {
  environment.systemPackages = [ start-hyprland-custom ];
}