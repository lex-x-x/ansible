#!/bin/bash

vhost=$1
check=$2
srvip=$3
param=$4

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "ERROR: not enough input data!"
    echo "usage: $0 <hostname> <http|time_*> <http server ip>"
    echo "usage: $0 <hostname> time_full_page <http server ip> [/index.php]"


    exit 1;
fi

case $check in
http)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{http_code}" -H "Host: $vhost" http://$srvip/  | sed 's/000/503/`
    exit 0;
  ;;

# The time, in seconds, it took from the start until the name resolving was completed.
time_namelookup)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_namelookup}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

# The time, in seconds, it took from the start until the TCP connect to the remote host (or proxy) was completed.
time_connect)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_connect}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

# The time, in seconds, it took from the start until the SSL/SSH/etc connect/handshake to the remote host was completed.
time_appconnect)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_appconnect}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

# The time, in seconds, it took from the start until the file transfer was just about to begin.
# This includes all pre-transfer commands and negotiations that are specific to the particular protocol(s) involved.
time_pretransfer)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_pretransfer}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

# The time, in seconds, it took for all redirection steps include name lookup, connect, pretransfer and transfer before
# the final transaction was started. time_redirect shows the complete execution time for multiple redirections.
time_redirect)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_redirect}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

# The time, in seconds, it took from the start until the first byte was just about to be transferred. This includes
# time_pretransfer and also the time the server needed to calculate the result.
time_starttransfer)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_starttransfer}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

#
time_total)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_total}" -H "Host: $vhost" http://$srvip/`
    exit 0;
  ;;

time_full_page)
    echo "$vhost" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/time -f '\t%e' /usr/bin/wget -pq --no-cache --delete-after --header "Host: $vhost" "http://$srvip$param"`
    exit 0;
  ;;

time_total_random)
    # showl generation time of random page on site $vhost
    # get page content
    randomurl=`/usr/bin/curl -s -L -o - -H "Host: $vhost" http://$srvip/ | \
    # get raw "a href"
    egrep 'href="[^><]+".*>' | \
    # exclude css and js includes
    egrep -v '<link ' | \
    # cleanup
    sed 's~^.*href="~~' | \
    sed 's~".*$~~g' | \
    # exclude js links and main page
    egrep -iv '#|^javascript|^/$' | \
    # relative links to full url
    sed "s~^\/~http://$vhost/~" | \
    sed "s~^\?~http://$vhost/\?~" | \
    # remove links to external domains
    egrep -i "^http[s]*://[^\/]*$vhost/" | \
    # randomaize list of links
    sort -R | \
    # show just one link
    head -n 1 | \
    sed "s~[w.]*$vhost~$srvip~"`
    echo "$vhost - $randomurl" >> /var/log/zabbix/vhost_check.log
    echo `/usr/bin/curl -s -L -o /dev/null -w "%{time_total}" -H "Host: $vhost" $randomurl`
  ;;

esac

# time wget -pq --no-cache --delete-after www.growingcraft.com
# -p makes it download all the resources (images, scripts, etc.)
# -q makes it quiet.
# The other options should be self-explanatory.
