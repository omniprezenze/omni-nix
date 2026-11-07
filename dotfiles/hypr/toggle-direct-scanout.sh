#!/usr/bin/env bash

set -euo pipefail

if ! current=$(hyprctl -j getoption render.direct_scanout | jq -er '.int | select(. == 0 or . == 1 or . == 2)'); then
    notify-send -u critical "Direct scanout" "Could not read the current setting"
    exit 1
fi

if [[ "$current" == 0 ]]; then
    next=1
    state="enabled"
else
    next=0
    state="disabled"
fi

if ! result=$(hyprctl eval "hl.config({ render = { direct_scanout = $next } })") || [[ "$result" != "ok" ]]; then
    notify-send -u critical "Direct scanout" "Could not change the setting"
    exit 1
fi

notify-send "Direct scanout" "$state"