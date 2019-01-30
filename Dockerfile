FROM openjdk:12-alpine

LABEL maintainer="louis@orleans.io"

# user-configurable vars
ENV EULA false
ENV RAM_MAX 8G

ENV JAR_DIR /server-jars

COPY . /

VOLUME /data
VOLUME /server-jars

WORKDIR /data

EXPOSE 25565

RUN apk add python3 && pip3 install -r /requirements.txt

ENTRYPOINT /start.sh

HEALTHCHECK CMD mcstatus localhost status || exit 1
