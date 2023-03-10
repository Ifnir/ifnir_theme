#!/bin/bash

## Files and Data
PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"

## Get CPU usage
get_cpu() {
	if [[ -f "${cpuFile}" ]]; then
		fileCont=$(cat "${cpuFile}")
		PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
		PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${cpuFile}"
	echo "${IDLE}" >> "${cpuFile}"
}

## Get Used memory
get_mem() {
	printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}

## Get Brightness
get_blight() {
	CARD=`ls /sys/class/backlight | head -n 1`

	if [[ "$CARD" == *"intel_"* ]]; then
		BNESS=`xbacklight -get`
		LIGHT=${BNESS%.*}
	else
		BNESS=`blight -d $CARD get brightness`
		PERC="$(($BNESS*100/255))"
		LIGHT=${PERC%.*}
	fi

	echo "$LIGHT"
}

## Get Battery 
get_battery() {
	BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
	cat /sys/class/power_supply/${BAT}/capacity
}

get_vol_amixer() {
	amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -l
}

get_vol_pulseaudio() {
	pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}

check_update() {
	checkupdates 2>/dev/null | wc -l
}

check_wifi() {
	if ip addr show wlan0 | grep -q 'state UP'; then
	 iwgetid -r
	else
	 echo "Offline"
	fi
}

## Execute accordingly
if [[ "$1" == "--cpu" ]]; then
	get_cpu
elif [[ "$1" == "--mem" ]]; then
	get_mem
elif [[ "$1" == "--blight" ]]; then
	get_blight
elif [[ "$1" == "--bat" ]]; then
	get_battery
elif [[ "$1" == "--volamixer" ]]; then
	get_vol_amixer	
elif [[ "$1" == "--volpulse" ]]; then
	get_vol_pulseaudio	
elif [[ "$1" == "--checkupdate" ]]; then
	check_update	
elif [[ "$1" == "--checkwifi" ]]; then
	check_wifi	
fi