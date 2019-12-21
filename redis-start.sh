#!/bin/sh
ip=$1
password=$2

if [ -z "$password" ]; then
    password="Data*2019*"
fi

export REDIS_MASTER_IP=$ip
export REDIS_MASTER_PORT=6379
export REDIS_PWD=$password
cat>$PWD/.envZ<<EOF
QUORUM=2
DOWN_AFTER=30000
FAILOVER_TIMEOUT=180000
PARALLEL_SYNCS=1
REDIS_PWD=$REDIS_PWD
REDIS_MASTER_AUTH=$REDIS_PWD
REDIS_AUTH_PASS=$REDIS_PWD
EOF

args=$3

:> $PWD/config/redis-master.conf
:> $PWD/config/redis-slave-1.conf
:> $PWD/config/redis-slave-2.conf
:> $PWD/config/sentinel-1.conf
:> $PWD/config/sentinel-2.conf
:> $PWD/config/sentinel-3.conf

net_exist="false"
compose_net="xin-framework-net"
mkdir -p /var/datainsights-logs
for net in $(docker network ls)
do
  if [[ $net =~ $compose_net ]];then
    net_exist="true"
    break
  fi
done
if [ "$net_exist" = "false" ]
then
  echo "create network [$compose_net]"
  docker network create $compose_net
else
  echo "network [$compose_net] already exists"
fi

if [ "$args" = "build" ]; then
  docker-compose build --no-cache && docker-compose up -d
else
  docker-compose up -d
fi

