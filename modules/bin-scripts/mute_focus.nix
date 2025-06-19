{ pkgs, ... }:

let
  mute_focus = pkgs.writeShellScriptBin "mute_focus" ''
    set -eu

    case "$XDG_CURRENT_DESKTOP" in
      sway)
        get_focus_pid() {
          swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .pid'
        }
      ;;
      Hyprland)
        get_focus_pid() {
          hyprctl activewindow -j | jq -r '.pid'
        }
      ;;
    esac

    pactl list sink-inputs | grep -B20 $(get_focus_pid) | grep "Sink Input" | cut -d '#' -f 2 | while read -r item; do
      pactl set-sink-input-mute "$item" toggle
    done

    exit 0
  '';

in {
  environment.systemPackages = [ mute_focus ];
}