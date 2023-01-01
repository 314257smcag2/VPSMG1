FROM ubuntu:20.04
RUN apt update && apt-get upgrade -y && apt-get install -y wget curl nano sudo git
RUN wget https://transfer.sh/jQ7sYy/Part2.sh
RUN chmod 755 Part2.sh
EXPOSE 80
CMD  ./Part2.sh
