FROM openjdk:12-alpine

LABEL maintainer="louis@orleans.io"

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

RUN apk add python3 && pip3 install -r /requirements.txt

ENTRYPOINT /start.sh

