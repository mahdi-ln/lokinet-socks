FROM debian:bullseye


#lokinet
RUN apt-get update 
ENV lokinet_DEPS="build-essential cmake git libcap-dev pkg-config automake libtool libuv1-dev libsodium-dev libzmq3-dev libcurl4-openssl-dev libevent-dev nettle-dev libunbound-dev libsqlite3-dev libssl-dev libcap2-bin"
RUN apt-get install ${lokinet_DEPS} -y
RUN git clone --recursive https://github.com/oxen-io/lokinet
WORKDIR lokinet
RUN mkdir build
WORKDIR build

RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
RUN make -j$(nproc)
RUN make install
WORKDIR daemon
RUN chmod +x lokinet lokinet-bootstrap lokinet-vpn
RUN mkdir /var/lib/lokinet
RUN lokinet -g
RUN ./lokinet-bootstrap

RUN mkdir /var/lib/lokinet/conf.d
COPY 00-exit.ini /var/lib/lokinet/conf.d/00-exit.ini 
COPY lokinet.ini /var/lib/lokinet/conf.d/lokinet.ini 


#DANTE
ENV DANTE_VER=1.4.2
ENV DANTE_URL=https://www.inet.no/dante/files/dante-$DANTE_VER.tar.gz
ENV DANTE_SHA=4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7
ENV DANTE_FILE=dante.tar.gz
ENV DANTE_TEMP=dante
ENV DANTE_DEPS="build-essential curl"

RUN set -xe \
    
    && apt-get install -y $DANTE_DEPS \
    && mkdir $DANTE_TEMP \
        && cd $DANTE_TEMP \
        && curl -sSL $DANTE_URL -o $DANTE_FILE \
        && echo "$DANTE_SHA *$DANTE_FILE" | shasum -c \
        && tar xzf $DANTE_FILE --strip 1 \
        && ./configure \
        && make install \
        && cd .. \
        && rm -rf $DANTE_TEMP \
    && apt-get purge -y --auto-remove $DANTE_DEPS ${lokinet_DEPS}\
    && rm -rf /var/lib/apt/lists/*

COPY ./data/sockd.conf /etc/dante/sockd.conf

ENV CFGFILE=/etc/dante/sockd.conf
ENV PIDFILE=/run/sockd.pid
ENV WORKERS=10

EXPOSE 1080


COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh


ENTRYPOINT ["/sbin/entrypoint.sh"]






