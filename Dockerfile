FROM openjdk:12-alpine

MAINTAINER Louis Orleans <louis@orleans.io>

# user-configurable vars
# ENV MINECRAFT_VERSION
ENV EULA false
ENV RAM_MAX 8G
ENV RAM_INIT 1g

ENV JAR_PATH /server-jars

COPY . /

WORKDIR /data
VOLUME /data

EXPOSE 25565

RUN apk add python3 && pip3 install requests

ENTRYPOINT /start.sh

