#!/usr/bin/env bash

active_window_json=$(hyprctl activewindow -j)

app_pid=$(echo "$active_window_json" | jq -r '.pid')
app_title=$(echo "$active_window_json" | jq -r '.initialTitle')
app_class=$(echo "$active_window_json" | jq -r '.initialClass')

audio_section=$(wpctl status | awk '/Audio/{flag=1; next} /Video/{flag=0} flag')
streams_section=$(echo "$audio_section" | awk '/Streams:/{flag=1;next} /^Video/{flag=0} flag')

stream_id=$(echo "$streams_section" \
    | grep -iE "^[[:space:]]*[0-9]+\.[[:space:]]*$app_title[[:space:]]*$" \
    | awk -F '.' '{print $1}' \
    | head -n 1)

if [ -z "$stream_id" ]; then
    stream_id=$(echo "$streams_section" \
    | grep -iE "^[[:space:]]*[0-9]+\.[[:space:]]*$app_class[[:space:]]*$" \
    | awk -F '.' '{print $1}' \
    | head -n 1)
fi

volume_line=$(wpctl get-volume "$stream_id")

current_volume=$(echo "$volume_line" | awk '{print $2}')
current_volume_float=$(printf "%.2f" "$current_volume")

if [ "$current_volume_float" = "0.00" ]; then
    wpctl set-volume -p $app_pid 100%
else
    wpctl set-volume -p $app_pid 0%
fi
