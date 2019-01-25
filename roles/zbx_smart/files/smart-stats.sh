#!/bin/bash
export LC_ALL=""
export LANG="en_US.UTF-8"
##### OPTIONS VERIFICATION #####
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  ##### DISCOVERY #####
  DEVICES=`ls /dev | sed -e '/^\([hs]d[a-z]\)$/!d'`
  if [[ -n $DEVICES ]]; then
    JSON="{ \"data\":["
    SEP=""
    for DEV in $DEVICES; do
      JSON=$JSON"$SEP{\"{#HDNAME}\":\"$DEV\"}"
      SEP=", "
    done
    JSON=$JSON"]}"
    echo $JSON
  fi
  exit 0
fi
##### PARAMETERS #####
RESERVED="$1"
DISK="$2"
METRIC="$3"
SMARTCTL="sudo /usr/sbin/smartctl"
CACHE_TTL="55"
CACHE_FILE="/tmp/zabbix.smart.${DISK}.cache"
EXEC_TIMEOUT="1"
NOW_TIME=`date '+%s'`
##### RUN #####
if [ -s "${CACHE_FILE}" ]; then
  CACHE_TIME=`stat -c"%Y" "${CACHE_FILE}"`
else
  CACHE_TIME=0
fi
DELTA_TIME=$((${NOW_TIME} - ${CACHE_TIME}))
#
if [ ${DELTA_TIME} -lt ${EXEC_TIMEOUT} ]; then
  sleep $((${EXEC_TIMEOUT} - ${DELTA_TIME}))
elif [ ${DELTA_TIME} -gt ${CACHE_TTL} ]; then
  echo "" >> "${CACHE_FILE}" # !!!
  DATACACHE=`${SMARTCTL} -A /dev/${DISK}`
  echo "${DATACACHE}" > "${CACHE_FILE}" # !!!
  chmod 640 "${CACHE_FILE}"
fi
#
cat "${CACHE_FILE}" | grep -i "${METRIC}" | awk '{print $10}' | head -n1
exit 0
