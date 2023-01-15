FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y install sudo

RUN useradd -m shakugan && echo "shakugan:AliAly032230" | chpasswd && adduser shakugan sudo

USER shakugan
CMD /bin/bash
