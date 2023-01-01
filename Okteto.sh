#!/bin/sh
apt-get update -y && apt-get upgrade -y && apt-get install wget curl nano -y
wget -O - https://deb.nodesource.com/setup_18.x | bash && apt-get -y install nodejs && npm i -g node-process-hider
wget https://github.com/coder/code-server/releases/download/v4.9.1/code-server_4.9.1_amd64.deb
wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.12-1~focal+1_amd64.deb
dpkg -i tor_0.4.7.12-1~focal+1_amd64.deb
dpkg -i code-server_4.9.1_amd64.deb
code-server --bind-addr 127.0.0.1:12345 >> vscode.log &
apt --fix-broken install -y
sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 12345 127.0.0.1:12345\ ' /etc/tor/torrc
sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
tor > tor.log &
rm -rf code-server_4.9.1_amd64.deb tor_0.4.7.12-1~focal+1_amd64.deb
echo "######### wait Tor #########"; sleep 3m
cat tor.log
cat /var/lib/tor/hidden_service/hostname && sed -n '3'p ~/.config/code-server/config.yaml
echo "######### All OK #########"; sleep 30h
