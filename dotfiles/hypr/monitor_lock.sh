#!/usr/bin/env bash

set -euo pipefail

argument=${1:-}
if [[ $# -gt 1 ]]; then
    printf 'Usage: monitor_lock.sh [status|monitor_index]\n' >&2
    exit 1
fi

case "$argument" in
    help|-h|-help|--help)
        printf 'Usage: monitor_lock.sh [status|monitor_index]\n'
        exit 0
        ;;
    ''|status) ;;
    *)
        if [[ ! "$argument" =~ ^[0-9]+$ || ${#argument} -gt 6 ]]; then
            printf 'Monitor index must be a non-negative integer.\n' >&2
            exit 1
        fi
        argument=$((10#$argument))
        ;;
esac

monitors=$(hyprctl -j monitors)
count=$(jq -er 'if type == "array" and length > 0 and all(.[]; (.name | type == "string" and length > 0) and (.x | type == "number") and (.y | type == "number") and (.focused | type == "boolean")) then length else error("invalid or empty monitor list") end' <<< "$monitors")

if [[ "$argument" != '' && "$argument" != status && "$argument" -ge "$count" ]]; then
    printf 'Monitor index must be between 0 and %s.\n' "$((count - 1))" >&2
    exit 2
fi

move_monitor() {
    local name=$1 x=$2 y=$3 index=$4 state=$5
    wlr-randr --output "$name" --pos "$x,$y"
    printf '%s monitor %s (%s)\n' "$state" "$index" "$name"
}

index=0
unlocked=0
while IFS=$'\t' read -r name x y focused; do
    if [[ "$argument" == status ]]; then
        if [[ "$y" == 0 ]]; then state=Unlocked; else state=Locked; fi
        printf 'Monitor %s (%s): %s\n' "$index" "$name" "$state"
    elif [[ "$argument" == '' && "$y" != 0 ]]; then
        move_monitor "$name" "$x" 0 "$index" Unlocked
        unlocked=1
    elif [[ "$argument" != '' && "$argument" == "$index" ]]; then
        if [[ "$y" == 0 ]]; then
            move_monitor "$name" "$x" 1152 "$index" Locked
        else
            move_monitor "$name" "$x" 0 "$index" Unlocked
        fi
        exit 0
    fi
    index=$((index + 1))
done < <(jq -r '.[] | [.name, .x, .y, .focused] | @tsv' <<< "$monitors")

if [[ "$argument" == '' && "$unlocked" == 0 ]]; then
    index=0
    while IFS=$'\t' read -r name x y focused; do
        if [[ "$focused" == true ]]; then
            move_monitor "$name" "$x" 1152 "$index" Locked
            exit 0
        fi
        index=$((index + 1))
    done < <(jq -r '.[] | [.name, .x, .y, .focused] | @tsv' <<< "$monitors")
    printf 'No focused monitor found.\n' >&2
    exit 1
fi