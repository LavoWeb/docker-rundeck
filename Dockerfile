# Dockerfile for rundeck

FROM debian:jessie

MAINTAINER Rémi Jouannet "remijouannet@gmail.com"

ENV SERVER_URL http://localhost:4440

RUN apt-get update
RUN apt-get install -y bash ca-certificates openjdk-7-jre-headless openssh-client pwgen curl git

ADD http://dl.bintray.com/rundeck/rundeck-deb/rundeck-2.6.2-1-GA.deb /tmp/rundeck.deb
#COPY ./rundeck-2.6.2-1-GA.deb /tmp/rundeck.deb
COPY . /app
WORKDIR /app
RUN useradd -d /var/lib/rundeck -s /bin/false rundeck

EXPOSE 4440 4443

CMD ./launch.sh
