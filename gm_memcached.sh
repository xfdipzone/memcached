#!/bin/sh

#memcached start and stop
#$1 action

ROOT=$(cd "$(dirname "$0")"; pwd)

. ${ROOT}/memcached_inc.sh


start() {

    if [ -f "$MEMCACHED_PID_FILE" ] && [ -s "$MEMCACHED_PID_FILE" ]; then
        printf "memcached already running\n"
    else
        printf "starting memcached\n"
        $MEMCACHED

        sleep 2

        PID=$(cat $MEMCACHED_PID_FILE)
        printf "memcached is started PID:$PID\n"

        printf "starting memcached daemon\n"
        ${ROOT}/${MEMCACHED_DAEMON_FILE} &
        DAEMON_PID=$!
        echo ${DAEMON_PID} > ${MEMCACHED_DAEMON_PID_FILE}
        printf "memcached daemon is started PID:${DAEMON_PID}\n"
    fi

}


stop() {

    if [ -f "$MEMCACHED_DAEMON_PID_FILE" ] && [ -s "$MEMCACHED_DAEMON_PID_FILE" ]; then
        DAEMON_PID=$(cat $MEMCACHED_DAEMON_PID_FILE)
        rm -f ${MEMCACHED_DAEMON_PID_FILE}
        if [ ! -z ${DAEMON_PID} ]; then
            kill -9 ${DAEMON_PID}
        fi
        printf "memcached daemon is stopped\n"
    else
        printf "no memcached daemon running\n"
    fi

    sleep 1

    if [ -f "$MEMCACHED_PID_FILE" ] && [ -s "$MEMCACHED_PID_FILE" ]; then
        PID=$(cat $MEMCACHED_PID_FILE)
        rm -f ${MEMCACHED_PID_FILE}
        if [ ! -z ${PID} ]; then
            kill -9 ${PID}
        fi
        printf "memcached is stopped\n"
    else
        printf "no memcached running\n"
    fi

}


case "$1" in

    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        sleep 3
        start
        ;;

    *)
        printf "Usage:$0 {start|stop|restart}\n"
        exit 1

esac

exit 0