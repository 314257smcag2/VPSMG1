FROM ubuntu:22.04

ENV USER_NAME SHAKUGAN
ENV ROOT_PASSWORD AliAly032230
ENV VNC_PASSWORD SHAKUGAN

RUN apt update && apt-get upgrade -y 
RUN apt install -y wget curl nano sudo git xz-utils dialog apt-utils tasksel slim; \
    apt clean;

# user
RUN useradd -m ${USER_NAME};\
    adduser ${USER_NAME} sudo; \
    echo '${USER_NAME}:${ROOT_PASSWORD}' | sudo chpasswd; \
    sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd; \
    echo root:${ROOT_PASSWORD} | chpasswd;

# sshd
RUN mkdir /run/sshd; \
    apt install -y openssh-server; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    apt clean;

# VSCODETOr
RUN wget https://github.com/coder/code-server/releases/download/v4.9.1/code-server_4.9.1_amd64.deb
RUN dpkg -i code-server_4.9.1_amd64.deb
RUN echo "code-server --bind-addr 127.0.0.1:12345 >> vscode.log &"  >>/VSCODETOr.sh
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
RUN echo "tor > tor.log &"  >>/VSCODETOr.sh
RUN rm -rf code-server_4.9.1_amd64.deb
RUN apt clean

# desktop
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 desktop-base xfce4-terminal firefox tightvncserver novnc
RUN bash -c 'echo \"exec /usr/bin/xfce4-session\" > /etc/X11/Xsession'

# novnc
RUN mkdir  /root/.vnc
RUN echo '${VNC_PASSWORD}' | vncpasswd -f > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd
RUN echo "su root -l -c 'vncserver :2000 ' "  >>/VSCODETOr.sh
RUN echo './utils/launch.sh  --vnc localhost:7900 --listen 8000 ' >>/VSCODETOr.sh
RUN echo 'echo "######### wait Tor #########"; sleep 3m ' >>/VSCODETOr.sh
RUN echo "cat /var/lib/tor/hidden_service/hostname" >>/VSCODETOr.sh
RUN echo "sed -n '3'p ~/.config/code-server/config.yaml" >>/VSCODETOr.sh

RUN chmod 755 /VSCODETOr.sh

EXPOSE 8080

CMD  ./VSCODETOr.sh
