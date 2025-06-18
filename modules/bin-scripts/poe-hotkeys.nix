{ pkgs, ... }:

let
  poe-hotkeys = pkgs.writeShellScriptBin "poe-hotkeys" ''
    case "$1" in
      1) c_str="/exit" ;;
      4) c_str="/kingsmarch" ;;
      5) c_str="/hideout" ;;
      *) exit 1 ;;
    esac

    case "$XDG_CURRENT_DESKTOP" in
    sway)
      # --- Sway Logic ---

      class="steam_app.*"
      instance="steam_app.*"
      title="Path of Exile"
      tree=$(swaymsg -t get_tree)

      con_id=$(echo "$tree" | jq --arg class "$class" --arg instance "$instance" --arg title "$title" '
      .. | select(.window_properties? and 
                  .window_properties.class? and 
                  .window_properties.instance? and 
                  .window_properties.title? and 
                  (.window_properties.class | test($class)) and 
                  (.window_properties.instance | test($instance)) and 
                  .window_properties.title == $title) | .id
      ')

      if [ -z "$con_id" ]; then
        exit 1
      fi

      # Focus the window, then use wtype to send the keys.
      # A small delay helps ensure the focus has shifted before typing begins.
      swaymsg "[con_id=$con_id] focus"
      sleep 0.1
      echo -e "keydelay 0\nkeyhold 0\ntypedelay 0\ntypehold 0\nkey enter\ntype $c_str\nkey enter" | dotool 
      ;;

    Hyprland)
      # --- Hyprland Logic ---
      read -r workspace_id client_address < <(hyprctl -j clients | jq -r '.[] | select((.title == "Path of Exile" or .title == "Path of Exile 2") and (.initialClass | test("^steam_app_.*"))) | "\(.workspace.id) \(.address)"')

      if [ -z "$workspace_id" ] || [ -z "$client_address" ]; then
        exit 1
      fi

      hyprctl --batch "dispatch workspace $workspace_id; dispatch focuswindow address:$client_address"

      sleep 0.1
      echo -e "keydelay 0\nkeyhold 0\ntypedelay 0\ntypehold 0\nkey enter\ntype $c_str\nkey enter" | dotool 
      ;;

    *)
      exit 1
      ;;
    esac

    exit 0
  '';

in {
  environment.systemPackages = [ poe-hotkeys ];
}