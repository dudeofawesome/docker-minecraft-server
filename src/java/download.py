#!/usr/bin/env python3

import os
import requests

manifest = requests.get("https://launchermeta.mojang.com/mc/game/version_manifest.json").json()

# minecraft_version = '';
# if "MINECRAFT_VERSION" not in os.environ:
#   minecraft_version = manifest['latest']['release']
# else:
minecraft_version = os.environ['MINECRAFT_VERSION']
if minecraft_version == 'release':
  minecraft_version = manifest['latest']['release']
elif minecraft_version == 'snapshot':
  minecraft_version = manifest['latest']['snapshot']

versions = manifest['versions']
json_url = ''
for i in versions:
  if i['id'] == minecraft_version:
    json_url = i['url']
    break

if json_url == '':
  print("No matching version found")
  exit(1)
download_info = requests.get(json_url).json()['downloads']['server']
if not download_info:
  print("No download URL found")
  exit(1)

print(f"{minecraft_version} {download_info['url']} {download_info['sha1']}")
