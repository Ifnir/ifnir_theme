#!/bin/bash

## Open folders in thunar
FILE="$HOME/.cache/eww_launch.dashboard"
CFG="$HOME/.config/eww"
EWW=`which eww`

close_dash() {
	${EWW} --config "$CFG" close \
					background profile system clock uptime github \
					reddit twitter youtube weather apps folders
	rm -rf "$FILE"
}

if [[ "$1" == "--dl" ]]; then
	close_dash && thunar ~/Downloads &

elif [[ "$1" == "--docs" ]]; then
	close_dash && thunar ~/Documents &

elif [[ "$1" == "--music" ]]; then
	close_dash && thunar ~/Music &

elif [[ "$1" == "--pics" ]]; then
	close_dash && thunar ~/Pictures &

elif [[ "$1" == "--cfg" ]]; then
	close_dash && thunar ~/.config &

elif [[ "$1" == "--local" ]]; then
	close_dash && thunar ~/.local/share &

fi