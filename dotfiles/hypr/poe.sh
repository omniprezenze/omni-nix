#!/run/current-system/sw/bin/bash

if [ "$1" == "1" ]; then
    c_str="/exit"
elif [ "$1" == "4" ]; then
    c_str="/kingsmarch"
elif [ "$1" == "5" ]; then
    c_str="/hideout"
fi

xdotool search --name "Path of Exile" windowactivate --delay 0
xdotool key Return
xdotool type --delay 0 "$c_str"
xdotool key Return
