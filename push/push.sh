#!/bin/bash
# Script for push our image to DockerHub
# Klimov Vitaliy 19.11.2020

echo "|-------------------------------------------|"
echo "|          Push image to DockerHub          |"
echo "|-------------------------------------------|"
echo "|------------Login to DockerHub-------------|"

docker login -u $USER_N -p $PASS

echo "|---------------Tagging image---------------|"
docker tag $IMAGE_N:$BUILD_TAG $USER_N/$IMAGE_N:$BUILD_TAG 

echo "|---------------Pushing image---------------|"
docker push $USER_N/$IMAGE_N:$BUILD_TAG

