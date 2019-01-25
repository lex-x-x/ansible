#!/bin/sh

arrays=`/sbin/mdadm --detail --scan | /bin/grep ARRAY | /usr/bin/awk '{ print $2 }'`
first="1"

echo '{ "data":[';
    for array in $arrays
    do

        if [ $first -ne 1 ]
        then
            echo ","
        else
            first="0"
        fi

        array_level=`/sbin/mdadm --detail $array | /bin/grep 'Raid Level :' | /bin/sed 's/^     Raid Level : //'`
        array_size=`/sbin/mdadm --detail $array | /bin/grep 'Array Size :' | /bin/sed 's/^.*iB //' | /bin/sed 's/)$//'`
        echo "{\"{#ARRAY}\":\"$array\",\"{#LEVEL}\":\"$array_level\",\"{#SIZE}\":\"$array_size\"}"

    done

echo ']}';

