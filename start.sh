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

  case "$MINECRAFT_VERSION" in
    "18w50a")
      DOWNLOAD_URL="https://launcher.mojang.com/v1/objects/de0577900a9071758d7f1172dd283bdbe88b7431/server.jar"
      ;;
    "1.13.2")
      DOWNLOAD_URL="https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar"
      ;;
    *)
      echo "Error: Unknown MINECRAFT_VERSION"
      exit 1
      ;;
  esac

  wget "$DOWNLOAD_URL" -O "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar"
fi

# java -server -XX:ParallelGCThreads=7 -Xms$RAM_INIT -Xmx$RAM_MAX -jar "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar" nogui --noconsole
java -server -Xms$RAM_INIT -Xmx$RAM_MAX \
  -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 \
  -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 \
  -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 \
  -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch \
  -XX:+ParallelRefProcEnabled \
  -jar "$JAR_PATH/mc-server-$MINECRAFT_VERSION.jar" \
  nogui # --noconsole

