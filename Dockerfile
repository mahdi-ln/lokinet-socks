FROM ubuntu:bionic-20181204
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* 

# Allow localnet to access proxy.
RUN sed -i "s/^#\+\(.*[acl|allow] localnet\)/\1/" /etc/squid/squid.conf



EXPOSE 3128/tcp

RUN apt install curl -y
RUN curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
RUN echo "deb https://deb.oxen.io bionic main" |  tee /etc/apt/sources.list.d/oxen.list
RUN apt update
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt install lokinet -y

#RUN ./lokinet-bootstrap


RUN apt install sudo libcap2-bin -y
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
RUN mkdir /var/lib/lokinet/conf.d
COPY 00-exit.ini /var/lib/lokinet/conf.d/00-exit.ini 
ENTRYPOINT ["/sbin/entrypoint.sh"]
