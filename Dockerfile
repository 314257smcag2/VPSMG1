FROM ubuntu:22.04
MAINTAINER "SHAKUGAN"

ENV ROOT_PASSWORD AliAly032230
ENV TZ America/New_York

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    apt-get install -y tzdata; \
    apt clean;

# timezone
RUN apt update && apt install -y wget apt-utils curl nano sudo git xz-utils; \
    apt-get upgrade -y && apt clean;

# sshd
RUN mkdir /run/sshd; \
    apt install -y openssh-server; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    apt clean;

# VSCODETOr
RUN wget https://github.com/coder/code-server/releases/download/v4.9.1/code-server_4.9.1_amd64.deb
RUN dpkg -i code-server_4.9.1_amd64.deb
RUN code-server --bind-addr 127.0.0.1:12345 >> vscode.log &
RUN wget -O - https://deb.nodesource.com/setup_18.x | bash && apt-get -y install nodejs && npm i -g updates
RUN apt-get install tor -y
RUN sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 12345 127.0.0.1:12345\ ' /etc/tor/torrc
RUN sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN tor > tor.log &
RUN rm -rf code-server_4.9.1_amd64.deb
RUN echo "######### wait Tor #########"; sleep 1m
RUN apt clean

# entrypoint
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
CMD    ["/usr/sbin/sshd", "-D", "-e", "cat /var/lib/tor/hidden_service/hostname && sed -n '3'p ~/.config/code-server/config.yaml"]
