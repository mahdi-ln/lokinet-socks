#!/bin/bash


echo 'nameserver 127.3.2.1' > /etc/resolv.conf;lokinet &

ENV CFGFILE=/etc/dante/sockd.conf
ENV PIDFILE=/run/sockd.pid
ENV WORKERS=10

sockd -f $CFGFILE -p $PIDFILE -N $WORKERS
