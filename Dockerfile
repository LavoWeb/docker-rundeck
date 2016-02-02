# Dockerfile for rundeck

FROM debian:jessie

MAINTAINER Rémi Jouannet "remijouannet@gmail.com"

#ENV http_proxy http://127.0.0.1:8080/
#ENV https_proxy http://127.0.0.1:8080/

ENV HOST_RUNDECK localhost
ENV SERVER_URL https://localhost:4443

RUN apt-get update
RUN apt-get install -y bash ca-certificates openjdk-7-jre-headless
RUN apt-get install -y bash openssh-client pwgen curl git

ADD http://dl.bintray.com/rundeck/rundeck-deb/rundeck-2.6.2-1-GA.deb /tmp/rundeck.deb
COPY . /app
WORKDIR /app
RUN useradd -d /var/lib/rundeck -s /bin/false rundeck

EXPOSE 4443

CMD ./launch.sh
