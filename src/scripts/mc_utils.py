import os
import requests

def get_mc_manifest_version(minecraft_version):
  manifest = requests.get("https://launchermeta.mojang.com/mc/game/version_manifest.json").json()

  # minecraft_version = '';
  # if "MINECRAFT_VERSION" not in os.environ:
  #   minecraft_version = manifest['latest']['release']
  # else:
  if minecraft_version == 'release':
    minecraft_version = manifest['latest']['release']
  elif minecraft_version == 'snapshot':
    minecraft_version = manifest['latest']['snapshot']
  minecraft_major_minor_version = '.'.join(minecraft_version.split('.')[:2])

  versions = manifest['versions']
  json_url = ''
  for i in versions:
    if i['id'] == minecraft_version:
      json_url = i['url']
      break

  if json_url == '':
    raise "No matching version found"

  return minecraft_version, minecraft_major_minor_version, json_url

def get_java_args(RAM_MAX):
  RAM_MAX = RAM_MAX.upper()
  max_ram = 0
  if RAM_MAX.endswith('G'):
    max_ram = double(RAM_MAX.replace('G', ''))
  elif RAM_MAX.endswith('M'):
    max_ram = double(RAM_MAX.replace('M', '')) / 1024

  G1NewSizePercent = 30
  G1MaxNewSizePercent = 40
  G1HeapRegionSize = 8
  G1ReservePercent = 20
  InitiatingHeapOccupancyPercent = 15

  if max_ram >= 12:
    G1NewSizePercent = 40
    G1MaxNewSizePercent = 50
    G1HeapRegionSize = 16
    G1ReservePercent = 15
    InitiatingHeapOccupancyPercent = 20

  return ' '.join([
    f'-Xms{max_ram}G',
    f'-Xmx{max_ram}G',
    f'-XX:+UseG1GC',
    f'-XX:+ParallelRefProcEnabled',
    f'-XX:MaxGCPauseMillis=200',
    f'-XX:+UnlockExperimentalVMOptions',
    f'-XX:+DisableExplicitGC',
    f'-XX:+AlwaysPreTouch',
    f'-XX:G1NewSizePercent={G1NewSizePercent}',
    f'-XX:G1MaxNewSizePercent={G1MaxNewSizePercent}',
    f'-XX:G1HeapRegionSize={G1HeapRegionSize}M',
    f'-XX:G1ReservePercent={G1ReservePercent}',
    f'-XX:G1HeapWastePercent=5',
    f'-XX:G1MixedGCCountTarget=4',
    f'-XX:InitiatingHeapOccupancyPercent={InitiatingHeapOccupancyPercent}',
    f'-XX:G1MixedGCLiveThresholdPercent=90',
    f'-XX:G1RSetUpdatingPauseTimePercent=5',
    f'-XX:SurvivorRatio=32',
    f'-XX:+PerfDisableSharedMem',
    f'-XX:MaxTenuringThreshold=1',
    f'-Dusing.aikars.flags=https://mcflags.emc.gs',
    f'-Daikars.new.flags=true',
  ])
