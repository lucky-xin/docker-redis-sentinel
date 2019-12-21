#!/bin/sh
cat>>/etc/redis/sentinel.conf<<EOF
port $PORT
sentinel monitor $REDIS_MASTER_NAME $REDIS_MASTER_IP $REDIS_MASTER_PORT $QUORUM
sentinel down-after-milliseconds $REDIS_MASTER_NAME $DOWN_AFTER
sentinel failover-timeout $REDIS_MASTER_NAME $FAILOVER_TIMEOUT
sentinel parallel-syncs $REDIS_MASTER_NAME $PARALLEL_SYNCS
sentinel auth-pass $REDIS_MASTER_NAME $REDIS_AUTH_PASS
EOF

exec redis-server /etc/redis/sentinel.conf --sentinel