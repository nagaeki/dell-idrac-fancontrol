#!/bin/bash

# Check if lm-sensors  and ipmitool are installed
if ! command -v sensors &>/dev/null || ! command -v ipmitool &>/dev/null; then
	echo "Please run setup.sh first."
	exit 1
fi

CPU0_TEMP=50
CPU1_TEMP=50
CPU_TEMP=50
WARNING_TEMP=65
DANGER_TEMP=75

get_cpu_temp() {
	CPU0_TEMP=$(sensors | grep 'Package id 0' | awk '{print $4}' | cut -c 2,3)
	CPU1_TEMP=$(sensors | grep 'Package id 1' | awk '{print $4}' | cut -c 2,3)
}

set_fan_speed() {
	if [ "$CPU0_TEMP" -gt "$CPU1_TEMP" ]; then
		CPU_TEMP=$CPU0_TEMP
	else CPU_TEMP=$CPU1_TEMP
	fi

	if [ "$CPU_TEMP" -gt "$DANGER_TEMP" ]; then
		ipmitool raw 0x30 0x30 0x02 0xff 0x32 2>/dev/null
	elif [ "$CPU_TEMP" -gt "$WARNING_TEMP" ]; then
		ipmitool raw 0x30 0x30 0x02 0xff 0x14 2>/dev/null
	else ipmitool raw 0x30 0x30 0x02 0xff 0x05 2>/dev/null
	fi
}

while true; do
	get_cpu_temp
	set_fan_speed
	sleep 1
done