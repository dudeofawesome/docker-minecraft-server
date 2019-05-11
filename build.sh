#!/usr/bin/env bash

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=dudeofawesome
# image name
IMAGE=minecraft-server

docker build -t $USERNAME/$IMAGE:latest .
