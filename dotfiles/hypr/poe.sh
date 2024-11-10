#!/usr/bin/env bash

case "$1" in
    1) c_str="/exit" ;;
    4) c_str="/kingsmarch" ;;
    5) c_str="/hideout" ;;
    *) exit 1 ;;
esac

client_list=$(hyprctl clients)

current_address=""
current_title=""
current_workspace_id=""

found=0

while IFS= read -r line; do
    if [[ $line =~ ^Window\ (.+) ]]; then
        current_address="${BASH_REMATCH[1]}"
        current_title=""
        current_workspace_id=""
    elif [[ $line =~ ^[[:space:]]+title:\ (.+) ]]; then
        current_title="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^[[:space:]]+workspace:\ (.+) ]]; then
        current_workspace_id="${BASH_REMATCH[1]}"
    fi

    if [[ "$current_title" == "Path of Exile" ]]; then
        workspace_id="$current_workspace_id"
        client_address="$current_address"
        found=1
        break
    fi
done <<< "$client_list"

if [ "$found" -ne 1 ] || [ -z "$workspace_id" ] || [ -z "$client_address" ]; then
    exit 1
fi

hyprctl dispatch workspace "$workspace_id"
hyprctl dispatch focuswindow "$client_address"

echo -e "keydelay 0\nkeyhold 0\ntypedelay 0\ntypehold 0\nkey enter\ntype $c_str\nkey enter" | dotool
