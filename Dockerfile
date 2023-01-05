FROM ubuntu:20.04
RUN apt update && apt-get upgrade -y && apt-get install -y wget curl nano sudo git
RUN wget https://raw.githubusercontent.com/314257smcag2/OTVSCODE/main/Okteto.sh
RUN chmod 755 Okteto.sh
EXPOSE 80
CMD  ./Okteto.sh
