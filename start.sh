#!/usr/bin/env sh

if "$EULA"; then
  echo "eula=true" > /data/eula.txt
else
  echo "Error: Minecraft server EULA needs to be accepted"
  echo "Set env var EULA to true to accept"
  exit 1
fi

if [ ! -f "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar" ]; then
  mkdir $JAR_PATH
fi

# apk add python3
# pip3 install requests

RES=$(python3 /download.py)
MINECRAFT_VERSION=$(echo $RES | cut -f 1 -d ' ')
DOWNLOAD_URL=$(echo $RES | cut -f 2 -d ' ')
DOWNLOAD_SHA1=$(echo $RES | cut -f 3 -d ' ')
# read MINECRAFT_VERSION DOWNLOAD_URL DOWNLOAD_SHA1 < <(python3 download.py)
wget "$DOWNLOAD_URL" -O "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar"

# java -server -XX:ParallelGCThreads=7 -Xms$RAM_INIT -Xmx$RAM_MAX -jar "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar" nogui --noconsole
java -server -Xms$RAM_INIT -Xmx$RAM_MAX \
  -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 \
  -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 \
  -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 \
  -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch \
  -XX:+ParallelRefProcEnabled \
  -jar "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar" \
  nogui # --noconsole
