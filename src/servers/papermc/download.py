#!/usr/bin/env python3

import os
import requests
from operator import itemgetter
from mc_utils import get_mc_manifest_version

minecraft_version, minecraft_major_minor_version, json_url = get_mc_manifest_version(os.environ['MINECRAFT_VERSION'])

downloads = requests.get(f"https://papermc.io/api/v2/projects/paper/version_group/{minecraft_major_minor_version}/builds").json()
builds = sorted(downloads['builds'], key=itemgetter('build'), reverse=True)
download_info = builds[0]['downloads']['application']
download_url = f"https://papermc.io/api/v2/projects/paper/versions/{minecraft_version}/builds/{builds[0]['build']}/downloads/{download_info['name']}"

print(f"{download_info['name']} {download_url} {download_info['sha256']}")
