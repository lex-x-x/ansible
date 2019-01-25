#!/bin/sh

cts=`sudo /usr/sbin/vzlist -a | egrep -v 'IP_ADDR' | awk '{ print $1 }'`
first="1"

echo '{ "data":[';
    for ct in $cts
    do

        if [ $first -ne 1 ]
        then
            echo ","
        else
            first="0"
        fi
        ct_hostname=`/usr/bin/sudo /usr/sbin/vzlist $ct | tail -n 1 | awk '{ print $5 }'`
        echo "{\"{#CTID}\":\"$ct\",\"{#HOSTNAME}\":\"$ct_hostname\"}"

    done

echo ']}';

