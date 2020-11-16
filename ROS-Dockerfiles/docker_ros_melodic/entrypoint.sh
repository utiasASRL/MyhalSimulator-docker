#!/usr/bin/env bash

set -e

source /opt/ros/melodic/setup.bash
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/$USER/catkin_ws/src/myhal_simulator/models
export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/home/$USER/catkin_ws/src/myhal_simulator/models
export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/home/$USER/catkin_ws/devel/lib

exec "$@"


