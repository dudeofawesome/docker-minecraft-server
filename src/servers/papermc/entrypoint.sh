#!/usr/bin/env sh

set -e

ls -lha /data

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

RES=$(python3 /download.py)
MINECRAFT_VERSION=$(echo $RES | cut -f 1 -d ' ')
BUILD_VERSION=$(echo $RES | cut -f 2 -d ' ')
DOWNLOAD_URL=$(echo $RES | cut -f 3 -d ' ')
DOWNLOAD_SHA256=$(echo $RES | cut -f 4 -d ' ')

JAR_PATH="$JAR_DIR/papermc-$MINECRAFT_VERSION-$BUILD_VERSION.jar"

if [ ! -f "$JAR_PATH" ]; then
  wget "$DOWNLOAD_URL" -O "$JAR_PATH"
  ACTUAL_SHA1=$(sha256sum "$JAR_PATH" | cut -f 1 -d ' ')
  if [ "$ACTUAL_SHA256" != "$DOWNLOAD_SHA256" ]; then
    echo "Server jar's SHA256 did not match!"
    exit 1
  fi
fi

echo "Starting Minecraft $MINECRAFT_VERSION server"

java -server -Xms$RAM_MAX -Xmx$RAM_MAX \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=30 \
  -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 \
  -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 \
  -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=32 \
  -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 \
  -Dusing.aikars.flags=https://mcflags.emc.gs \
  -Daikars.new.flags=true \
  -jar "$JAR_PATH" \
  --nogui

if [ $? -ne 0 ]; then
  echo "You might have a memory issue"
  echo "Try decreasing RAM_MAX"
  exit 1
fi

echo "Minecraft server stopped"
