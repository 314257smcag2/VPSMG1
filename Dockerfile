FROM ubuntu:20.04
RUN apt update && apt-get upgrade -y && apt-get install -y wget curl nano sudo git
RUN wget https://raw.githubusercontent.com/314257smcag2/VPSMG0/main/Proot.sh
RUN chmod 755 Proot.sh
EXPOSE 80
CMD  ./Proot.sh
