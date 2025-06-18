{ pkgs, ... }:
let
  screenshotter = pkgs.writeShellScriptBin "screenshotter" ''
    set -eu

      take_screenshot() {
        grim "$@" - | wl-copy
        notify-send "Screenshotted" "Saved to clipboard"
      } 

    case "$1" in
      monitor)
        case "$XDG_CURRENT_DESKTOP" in
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
        take_screenshot -g "$(slurp -w 0)"
        ;;

      *) 
        notify-send "Error" "$0 {monitor|area}"
        exit 1 
        ;;
    esac
    
    exit 0
  '';

in {
  environment.systemPackages = [ screenshotter ];
}