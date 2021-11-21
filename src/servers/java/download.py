#!/usr/bin/env python3

import os
import requests
from mc_utils import get_mc_manifest_version

minecraft_version, minecraft_major_minor_version, json_url = get_mc_manifest_version(os.environ['MINECRAFT_VERSION'])

download_info = requests.get(json_url).json()['downloads']['server']
if not download_info:
  print("No download URL found")
  exit(1)

print(f"{minecraft_version} {download_info['url']} {download_info['sha1']}")
