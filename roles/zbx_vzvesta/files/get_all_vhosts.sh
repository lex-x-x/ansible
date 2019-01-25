#!/bin/sh

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

#cts=`sudo /usr/sbin/vzlist -a | egrep -v 'IP_ADDR' | awk '{ print $1 }'`
vhosts=`/bin/cat /var/lib/vz/root/*/usr/local/vesta/data/users/*/web.conf | awk '{ print $1 }' | sed "s/^DOMAIN='//" | sed "s/'$//"`
first="1"

echo '{ "data":[';
    for vhost in $vhosts
    do

        if [ $first -ne 1 ]
        then
            echo ","
        else
            first="0"
        fi
        vhostip=`sudo /bin/bash -c "/bin/cat /var/lib/vz/root/*/usr/local/vesta/data/users/*/web.conf" | grep "DOMAIN='$vhost'" | awk '{ print $2 }' | head -n 1 | sed "s/^IP='//" | sed "s/'$//"`
        echo "{\"{#VHOST}\":\"$vhost\",\"{#VHOSTIP}\":\"$vhostip\"}"

    done

echo ']}';

