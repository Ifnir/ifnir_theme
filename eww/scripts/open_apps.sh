#!/bin/bash

## Open Applications
FILE="$HOME/.cache/eww_launch.dashboard"
CFG="$HOME/.config/eww"
EWW=`which eww`

close_dash() {
	${EWW} --config "$CFG" close \
					background profile system clock uptime github \
					reddit twitter youtube weather apps folders
	rm -rf "$FILE"
}

if [[ "$1" == "--ff" ]]; then
	close_dash && firefox &

elif [[ "$1" == "--tg" ]]; then
	close_dash && telegram-desktop &

elif [[ "$1" == "--dc" ]]; then
	close_dash && discord &

elif [[ "$1" == "--tr" ]]; then
	close_dash && alacritty --working-directory ~ &

elif [[ "$1" == "--fm" ]]; then
	close_dash && thunar ~ &

elif [[ "$1" == "--ge" ]]; then
	close_dash && geany &

elif [[ "$1" == "--cd" ]]; then
	close_dash && code &

elif [[ "$1" == "--gp" ]]; then
	close_dash && gimp &

elif [[ "$1" == "--vb" ]]; then
	close_dash && virtualbox &

fi