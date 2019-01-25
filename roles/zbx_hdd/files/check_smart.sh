#!/bin/bash

# Output SMART's data for compatible block devices

if [ -z "$1" ] || [ -z "$2" ]; then
    echo ""
    echo "ERROR: not enough input data!"
    echo "usage: $0 <device> <smart_parameter> [raw]"
    echo ""
    exit 1;
fi

device=$1
param=$2
data=$3

if [ "$data" == "raw" ]; then
    echo `/usr/sbin/smartctl -a $device | /bin/grep "$param" | /usr/bin/awk '{ print $10 }'`
else
    echo `/usr/sbin/smartctl -a $device | /bin/grep "$param" | /usr/bin/awk '{ print $4 }' | /bin/sed 's/^0*//'`
fi

