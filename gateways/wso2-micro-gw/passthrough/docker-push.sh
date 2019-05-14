#!/bin/sh
echo 'Pushing docker image to registry'
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push nuwanbando/employees:v1