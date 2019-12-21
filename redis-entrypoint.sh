#!/bin/sh

set -e

CONFIG_FILE=${CONFIG_FILE:-/usr/local/etc/redis/redis.conf}
cat>>$CONFIG_FILE<<EOF
bind 0.0.0.0
port $PORT
appendonly yes
notify-keyspace-events Eglx
daemonize no
logfile redis-$PORT.log
EOF

if [ "$REDIS_PWD" ]; then
   echo "requirepass $REDIS_PWD" >> $CONFIG_FILE
fi

if [ "$REDIS_MASTER_AUTH" ]; then
  echo "masterauth $REDIS_MASTER_AUTH" >> $CONFIG_FILE
fi

if [ "$REDIS_MASTER_IP" ] && [ "$REDIS_MASTER_PORT" ]; then
  echo "slaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT" >> $CONFIG_FILE
fi

exec redis-server /usr/local/etc/redis/redis.conf
