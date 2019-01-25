#!/bin/bash

# Userful docs:
# https://www.kernel.org/doc/Documentation/md.txt

if [ -z "$1" ]; then
    echo ""
    echo "ERROR: not enough input data!"
    echo "usage: $0 <device>"
    echo "example: $0 /dev/md0"
    echo ""
    exit 1;
fi


array=`echo $1 | /bin/sed 's/\/dev\///'`

state=`/sbin/mdadm --detail /dev/$array | /bin/grep 'State : ' | /bin/sed 's/^.*State : //' | /bin/sed 's/[[:space:]]*$//'`

if [ "$state" == "clean" ] || [ "$state" == "active" ]; then
    state="0"
else
    state="1"
fi

arrayname=`/bin/echo $array | /bin/sed 's/\///'`
degraded=`cat /sys/block/$arrayname/md/degraded`

if [ "$state" -ne 0 ] || [ "$degraded" -ne 0 ]; then
    echo "1"
else
    echo "0"
fi
