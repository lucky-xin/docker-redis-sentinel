#!/bin/sh

{
  echo "port $PORT"
  echo "sentinel monitor $REDIS_MASTER_NAME $REDIS_MASTER_IP $REDIS_MASTER_PORT $QUORUM"
  echo "sentinel down-after-milliseconds $REDIS_MASTER_NAME $DOWN_AFTER"
  echo "sentinel failover-timeout $REDIS_MASTER_NAME $FAILOVER_TIMEOUT"
  echo "sentinel parallel-syncs $REDIS_MASTER_NAME $PARALLEL_SYNCS"
  echo "sentinel auth-pass $REDIS_MASTER_NAME $REDIS_AUTH_PASS"
} >> /etc/redis/sentinel.conf

exec redis-server /etc/redis/sentinel.conf --sentinel