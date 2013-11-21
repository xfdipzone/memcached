#!/bin/sh

#config include

HOST=$(hostname)
SITE="mysite"
PORT=11211

MEMCACHED_PID_FILE="/tmp/memcached.pid"
MEMCACHED_DAEMON_PID_FILE="/tmp/memcached_daemon.pid"

MEMCACHED="memcached -d -m 64 -p $PORT -u memcache -l 127.0.0.1 -P $MEMCACHED_PID_FILE"
MEMCACHED_DAEMON_FILE="memcached_daemon.sh"

ERROR_LOG_FILE="${ROOT}/memcached_${SITE}_${HOST}_${PORT}.log"

NOTICE_EMAIL='me@gmail.com'