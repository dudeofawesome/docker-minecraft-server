#!/usr/bin/env sh

if "$EULA"; then
  echo "eula=true" > /data/eula.txt
else
  echo "Error: Minecraft server EULA needs to be accepted"
  echo "Set env var EULA to true to accept"
  exit 1
fi

if [ ! "$MINECRAFT_VERSION" ]; then
  echo "You must set MINECRAFT_VERSION in env."
  echo "Specify a version of Minecraft, like '1.13.2'"
  echo "'release' will keep you always up to date, which may mean upgrading before you meant to"
  echo "'snapshot' will keep you up to date on the latest snapshot"
  exit 1
fi

# apk add python3
# pip3 install requests

RES=$(python3 /download.py)
MINECRAFT_VERSION=$(echo $RES | cut -f 1 -d ' ')
DOWNLOAD_URL=$(echo $RES | cut -f 2 -d ' ')
DOWNLOAD_SHA1=$(echo $RES | cut -f 3 -d ' ')

JAR_PATH="$JAR_DIR/mc-server-$MINECRAFT_VERSION.jar"

if [ ! -f "$JAR_PATH" ]; then
  wget "$DOWNLOAD_URL" -O "$JAR_PATH"
  ACTUAL_SHA1=$(sha1sum "$JAR_PATH" | cut -f 1 -d ' ')
  if [ "$ACTUAL_SHA1" != "$DOWNLOAD_SHA1" ]; then
    echo "Server jar's SHA1 did not match!"
    exit 1
  fi
fi

echo "Starting Minecraft $MINECRAFT_VERSION server"

java -server -Xms$RAM_MAX -Xmx$RAM_MAX \
  -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 \
  -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 \
  -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 \
  -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch \
  -XX:+ParallelRefProcEnabled \
  -jar "$JAR_PATH" \
  nogui # --noconsole

echo "Minecraft server stopped"
