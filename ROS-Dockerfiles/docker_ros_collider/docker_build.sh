#!/bin/bash

username=$USER
userid=$UID

echo $username
echo $userid

echo ""
echo "Building image docker_ros_box"
echo ""

docker image build --build-arg username0=$username \
--build-arg userid0=$userid \
--shm-size=64g -t \
docker_ros_collider_$username .