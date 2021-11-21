#!/usr/bin/env python3

import os
import requests
from mc_utils import get_mc_manifest_version

minecraft_version, minecraft_major_minor_version, json_url = get_mc_manifest_version(os.environ['MINECRAFT_VERSION'])

print(f"{minecraft_version}")
