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

RUN apt update -y
RUN apt install git pkg-config python3-pip python3-venv -y
RUN git clone --recursive https://github.com/zeronet-conservancy/zeronet-conservancy.git
RUN mv ./zeronet-conservancy ./irangeek
RUN cd irangeek 
RUN python3 -m venv venv
#RUN source ./venv/bin/activate
#RUN python3 -m pip install -r ./requirements.txt
EXPOSE 43110/tcp
ARG USERNAME="dock"
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME 

# TODO: Various optional modules are currently disabled (see output of ./configure):
# - Libwrap is disabled because tcpd.h is missing.
# - BSD Auth is disabled because bsd_auth.h is missing.
# - ...

RUN set -x \
    # Runtime dependencies.
 && apt install dante-server -y\ 
    # Build dependencies.

    # Add an unprivileged user.
 && useradd --uid  8062 -m sockd \
&& curl -Lo /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /usr/local/bin/dumb-init \
    # Clean up.
 && rm -rf /tmp/* 



EXPOSE 1080




ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["sockd"]

