FROM ubuntu:20.04
RUN apt update
RUN apt-get upgrade -y
RUN apt-get install -y wget curl nano sudo git xz-utils
RUN wget https://raw.githubusercontent.com/314257smcag2/VPSMG0/main/Proot.sh
RUN chmod 755 Proot.sh
EXPOSE 80
CMD  ./Proot.sh
