{ pkgs, ... }:
let
  screenshotter = pkgs.writeShellScriptBin "screenshotter" ''
    set -euo pipefail

      take_screenshot() {
        grim "$@" - | wl-copy
      } 

    case "''${1:-}" in
      monitor)
        case "''${XDG_CURRENT_DESKTOP:-}" in
          sway)
            monitor=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
            take_screenshot -o "$monitor"
          ;;
          Hyprland)
            monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
            take_screenshot -o "$monitor"
          ;;
          *)
            notify-send "Error" "Unsupported desktop for screenshotter"
            exit 1 
          ;;
        esac
        ;;

      area)
        geometry=$(slurp -w 0)
        take_screenshot -g "$geometry"
      ;;

      *) 
        printf 'Usage: %s {monitor|area}\n' "$0" >&2
        exit 1 
      ;;
    esac
    
    exit 0
  '';

in {
  environment.systemPackages = [ screenshotter ];
}