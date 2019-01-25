#!/bin/bash

CTID=$1
Q=$2
PARAM=$3

case $Q in
la)
    echo `/usr/bin/sudo /usr/sbin/vzlist -o laverage $CTID | sed 's/\// /' | sed 's/\// /' | awk '{ print $1 }' | tail -n 1`
    exit 0;
  ;;
diskspace)
    echo `sudo du -sx \`sudo /usr/sbin/vzlist -o private $CTID | tail -n 1\` | awk '{ print $1 }'`
    exit 0;
  ;;
ioacct)
    echo `sudo cat /proc/bc/$CTID/ioacct | grep $3 | awk '{ print $2 }'`
    exit 0;
  ;;
exim.ql)
    echo `/usr/sbin/vzctl exec $CTID "exim -bpc"`
    exit 0;
  ;;
*)
    echo `/usr/bin/sudo /usr/sbin/vzlist -o $Q $CTID | tail -n 1 | awk '{ print $1 }'`;
    exit 0;
  ;;
esac
