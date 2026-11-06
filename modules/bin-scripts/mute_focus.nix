{ pkgs, ... }:

let
  mute_focus = pkgs.writeShellScriptBin "mute_focus" ''
    set -euo pipefail

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
      *)
        exit 1
      ;;
    esac

    pid=$(get_focus_pid)
    case "$pid" in
      ""|null|*[!0-9]*) exit 0 ;;
    esac

    pactl -f json list sink-inputs | jq -r --arg pid "$pid" \
      '.[] | select((.properties["application.process.id"] // "" | tostring) == $pid) | .index' | while read -r item; do
      pactl set-sink-input-mute "$item" toggle
    done

    exit 0
  '';

in {
  environment.systemPackages = [ mute_focus ];
}