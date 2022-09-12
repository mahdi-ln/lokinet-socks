#!/bin/bash


echo 'nameserver 127.3.2.1' > /etc/resolv.conf;lokinet &


while  [ ! -d "/sys/class/net/lokitun0" ]
do
:
done
sockd -f $CFGFILE -p $PIDFILE -N $WORKERS