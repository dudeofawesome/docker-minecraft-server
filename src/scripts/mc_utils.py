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
