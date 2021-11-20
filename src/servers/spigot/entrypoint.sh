#!/usr/bin/env sh

set -e

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
DOWNLOAD_URL=$(echo $RES | cut -f 2 -d ' ')
DOWNLOAD_SHA1=$(echo $RES | cut -f 3 -d ' ')

JAR_PATH="$JAR_DIR/spigot-$MINECRAFT_VERSION.jar"

if [ ! -f "$JAR_PATH" ]; then
  pushd /mc-server
  java -jar /mc-server/BuildTools.jar --rev "$MINECRAFT_VERSION"
  if [ ! -f "./spigot-$MINECRAFT_VERSION.jar" ]; then
    >&2 echo "Failed to create spigot server jar"
    exit 1
  fi
  mv "./spigot-$MINECRAFT_VERSION.jar" "$JAR_PATH"
  popd
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

if [ $? -ne 0 ]; then
  echo "You might have a memory issue"
  echo "Try decreasing RAM_MAX"
  exit 1
fi

echo "Minecraft server stopped"
