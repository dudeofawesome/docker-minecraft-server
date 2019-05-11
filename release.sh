#!/usr/bin/env bash

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=dudeofawesome
# image name
IMAGE=minecraft-server

# ensure we're up to date
git pull

# bump version
# docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=$(cat VERSION)
echo "version: $VERSION"

# run build
./build.sh

# tag it
git add -A
git commit -m "🚀🔖 v$VERSION"
git tag -a "$VERSION" -m "v$VERSION"
git push
git push --tags

docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$VERSION
