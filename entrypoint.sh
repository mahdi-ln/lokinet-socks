#!/bin/bash


echo 'nameserver 127.3.2.1' > /etc/resolv.conf;./lokinet &

ENV CFGFILE=/etc/dante/sockd.conf
ENV PIDFILE=/run/sockd.pid
ENV WORKERS=10

while  [ ! -d "/sys/class/net/lokitun0" ]
done
sockd -f $CFGFILE -p $PIDFILE -N $WORKERS