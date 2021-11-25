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
JAR_NAME=$(echo $RES | cut -f 1 -d ' ')
DOWNLOAD_URL=$(echo $RES | cut -f 2 -d ' ')
DOWNLOAD_SHA256=$(echo $RES | cut -f 3 -d ' ')

JAR_PATH="$JAR_DIR/$JAR_NAME"

if [ ! -f "$JAR_PATH" ]; then
  wget "$DOWNLOAD_URL" -O "$JAR_PATH"

  ACTUAL_SHA256=$(sha256sum "$JAR_PATH" | cut -f 1 -d ' ')
  if [ "$ACTUAL_SHA256" != "$DOWNLOAD_SHA256" ]; then
    echo "Server jar's SHA256 did not match!"
    rm "$JAR_PATH"
    exit 1
  fi
fi

echo "Starting Minecraft $MINECRAFT_VERSION server"

JAVA_ARGS=$(PYTHONPATH=/ python3 -c "import mc_utils; print(mc_utils.get_java_args('$RAM_MAX'))")

java -server $JAVA_ARGS \
  -jar "$JAR_PATH" \
  --nogui

if [ $? -ne 0 ]; then
  echo "You might have a memory issue"
  echo "Try decreasing RAM_MAX"
  exit 1
fi

echo "Minecraft server stopped"
