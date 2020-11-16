# Dockerfiles and run files used for the Myhal Simulator project

## Docker images

Two docker image folders are provided: `docker_ros_melodic` and `docker_ros_noetic`.

 - `docker_ros_melodic` contains the dockerfile that builds the ROS melodic docker image. This is the main docker image. It is used to run the gazebo simulation and all the robot navigation stack

 - `docker_ros_noetic` contains the dockerfile that builds the ROS noetic docker image. This image is used to run the deep learning prediction. We can connect a container running on this image to the main container (running on the melodic image). This container will recieve the lidar point clouds, perform deep predictions, and publish the classifications. The main container will use this classifications


## Run Files

There are several running scripts. First the two main scripts are:

 - `melodic_docker.sh`: Starts a container on the `docker_ros_melodic` image. This is the main file to start the simulation with a robot performing a tour (see MyhalSimulator repo for details). Tip: you can use this as is to start a container and attach it to a Visual Studio Code workspace.
 - `noetic_docker.sh`: Start a container on the `docker_ros_noetic` image. (Same tip with vscode)
 - `classification_test.sh`: Start two containers on `docker_ros_melodic` and  `docker_ros_noetic` images. This script is used in the same way as `melodic_docker.sh` but only if we need deep network predictions.
 - `classification_test_2.sh`: Same as above but the two containers are started in a different order. Ignore this one

 Then useful scripts to run multiple experiments onbe after the other are provided:

 - `multi_tours.sh`: runs multiple experiments with different parameters. Customize this file as you want for your own experiments
 - `nohup_multi_tours.sh`: runs the `multi_tours.sh` in nohup mode so that you can close your ssh session and let the code run on the remote machine

 Eventually debug script are also provided

 - `connect_to_container.sh`: connect to a container currently running (opens a bash terminal in it so that you can print ROS stuff)
 - `root_in_container.sh`: same but as root (use it with caution)
 - `dashboard_docker.sh`: old ignore this one


To avoid ROS master conflicts when running multiple ROS containers on the same machine, the running scripts will incremement a local variable called `ROSPORT`. If not initially set, it will default to 1100. `export ROSPORT=<value>` will be appended to your ~/.bashrc file, over-writing a previous `export ROSPORT` statement if it is there. 
To ensure that the enviroment variable is changed in your local terminal, either run the script with `source melodic_docker.sh`, or after running a script use `source ~/.bashrc`.

### Melodic and Noetic Flags

-d, if set it will run the container in detached mode

-c [arg], will run the argument as a command in the container 

For example calling `source melodic_docker.sh -c "catkin build" -d` will run `catkin build` in a detached ROS melodic docker container.
