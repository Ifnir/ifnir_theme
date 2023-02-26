#!/bin/bash

## Open links in firefox
FILE="$HOME/.cache/eww_launch.dashboard"
CFG="$HOME/.config/eww"
EWW=`which eww`
cmd="firefox --new-tab"

close_dash() {
	${EWW} --config "$CFG" close \
					background profile system clock uptime github \
					reddit twitter youtube weather apps folders
	rm -rf "$FILE"
}

if [[ "$1" == "--mail" ]]; then
	close_dash && ${cmd} "https://mail.google.com"

elif [[ "$1" == "--gh" ]]; then
	close_dash && ${cmd} "https://github.com"

elif [[ "$1" == "--rd" ]]; then
	close_dash && ${cmd} "https://reddit.com"

elif [[ "$1" == "--tw" ]]; then
	close_dash && ${cmd} "https://twitter.com"

elif [[ "$1" == "--yt" ]]; then
	close_dash && ${cmd} "https://youtube.com"

fi