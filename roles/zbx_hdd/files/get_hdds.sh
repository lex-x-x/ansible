#!/bin/sh

#cts=`sudo /usr/sbin/vzlist -a | egrep -v 'IP_ADDR' | awk '{ print $1 }'`
hdds=`/usr/sbin/smartctl --scan | /usr/bin/awk '{ print $1 }'`
first="1"

echo '{ "data":[';
    for hdd in $hdds
    do

        if [ $first -ne 1 ]
        then
            echo ","
        else
            first="0"
        fi
#        ct_hostname=`/usr/bin/sudo /usr/sbin/vzlist $ct | tail -n 1 | awk '{ print $5 }'`
        hdd_model=`/usr/sbin/smartctl -a $hdd | /bin/grep "Device Model:" | /bin/sed 's/Device Model:     //'`
        hdd_serial=`/usr/sbin/smartctl -a $hdd | /bin/grep "Serial Number:" | /bin/sed 's/Serial Number:    //'`
        hdd_size=`/usr/sbin/smartctl -a /dev/sda | /bin/grep "User Capacity:" | /bin/sed 's/^.* \[//' | /bin/sed 's/\]$//'`
        echo "{\"{#HDDDEV}\":\"$hdd\",\"{#HDDMODEL}\":\"$hdd_model\",\"{#HDDSERIAL}\":\"$hdd_serial\",\"{#HDDSIZE}\":\"$hdd_size\"}"
    done

echo ']}';

