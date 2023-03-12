#!/usr/bin/env bash

# Add this script to your wm startup file.



# Terminate already running bar instances
killall -q eww

# Wait until the processes have been shut down
while pgrep -u $UID -x eww >/dev/null; do sleep 1; done

# Launch the eww
~/.local/bin/eww daemon &
~/.local/bin/eww open bottombar &
