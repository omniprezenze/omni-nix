{ pkgs, config, ... }:
let
  start-hyprland-custom = pkgs.writeShellScriptBin "start-hyprland-custom" ''
    set -eu

    HYPRLAND_BINARY="/run/current-system/sw/bin/start-hyprland"
    HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland_${config.networking.hostName}.conf"

    exec "$HYPRLAND_BINARY" -- -c "$HYPRLAND_CONFIG"
  '';
in {
  environment.systemPackages = [ start-hyprland-custom ];
}