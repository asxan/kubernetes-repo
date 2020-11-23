#!/bin/bash
# Script for build docker image od Django-project: BoozeShop
# Vitalii Klimov 19.11.2020
echo "--------------------------------------------------------|"
echo "|                 Copy all project file                 |"
echo "|-------------------------------------------------------|"
# Copy all project file
cp -r  $PWD/pythonapp/BoozeShop/Store/.  $PWD/build/
echo "|-------------------------------------------------------|"
echo "|                 CD to jenkins build                   |"
echo "|-------------------------------------------------------|"
cd  build/
echo "|-------------------------------------------------------|"
echo "|                     Build image                       |"
echo "|-------------------------------------------------------|"
# Build image
docker build -t -f --no-cache $IMAGE_N:$BUILD_TAG Dockerfile-Python
echo "|-------------------------------------------------------|"
echo "|                 Delete all project file               |"
echo "|-------------------------------------------------------|"
# Delete all project file
rm -rf .idea/ BoozeStore/ requirements.txt

