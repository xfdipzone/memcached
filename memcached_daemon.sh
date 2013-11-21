#!/bin/sh

#memcached daemon

ROOT=$(cd "$(dirname "$0")"; pwd)

. ${ROOT}/memcached_inc.sh


while :
do
    if [ -f "$MEMCACHED_PID_FILE" ] && [ -s "$MEMCACHED_PID_FILE" ]; then
        PID=$(cat $MEMCACHED_PID_FILE)
    else
        PID=""
    fi
   
    if [ -z "$PID" ] || [ -z $(ps aux|awk '{print $2}' | grep "^$PID$") ]; then
        $MEMCACHED
        sleep 1
        printf "[$(date +%Y-%m-%d' '%H:%M:%S)] ${SITE} ${HOST} memcached ${PORT} is restarted\n" >> $ERROR_LOG_FILE
        echo "Subject: ${SITE} ${HOST} memcached ${PORT} is restarted $(date +%Y-%m-%d' '%H:%M:%S)" | sendmail "${NOTICE_EMAIL}"
    fi

    sleep 5

done

exit 0