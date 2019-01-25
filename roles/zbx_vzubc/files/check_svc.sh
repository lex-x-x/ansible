#!/bin/bash

#!/bin/bash

# IP address to check service
IP=$1
# Service to check: http, smtp etc ...
SVC=$2
# reserved
PARAM=$3
# Check TCP port by default
TCP_PROBE='yes'
PORT=''

case $SVC in
ssh)
    PORT=22
  ;;
http)
    PORT=80
  ;;
vesta)
    PORT=8083
  ;;
pop3)
    PORT=110
  ;;
imap)
    PORT=143
  ;;
smtp)
    PORT=25
  ;;
mysql)
    PORT=3306
  ;;
dns)
    TCP_PROBE='no'
    /usr/bin/dig  +time=2 +tries=1 ns @$IP localhost > /dev/null ; /bin/echo $?
  ;;
*)
    echo "malformed request!"
    exit 1;
  ;;
esac

if [ "$TCP_PROBE" == 'yes' ] ; then
    /bin/nc -z -w5 $IP $PORT ; echo $?
fi
