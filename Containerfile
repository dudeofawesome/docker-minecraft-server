FROM openjdk:18-alpine

LABEL maintainer="louis@orleans.io"

# user-configurable vars
ENV EULA false
ENV RAM_MAX 8G

ENV JAR_DIR /server-jars

ADD VERSION .

COPY entrypoint.sh /
COPY download.py /
COPY requirements.txt /

VOLUME /data
VOLUME /server-jars

WORKDIR /data

EXPOSE 25565
# RCON port
EXPOSE 25575

RUN apk add python3 py3-pip && \
  python3 -m pip install -r /requirements.txt

COPY Containerfile /
COPY LICENSE /
COPY README.md /

ENTRYPOINT /entrypoint.sh

HEALTHCHECK CMD mcstatus localhost status || exit 1
