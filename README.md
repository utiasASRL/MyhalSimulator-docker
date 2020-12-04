# Dockerfiles and run files used for the Myhal Simulator project
# Docker images description

Two docker image folders are provided: `docker_ros_melodic` and `docker_ros_noetic`.

 - `docker_ros_melodic` contains the dockerfile that builds the ROS melodic docker image. This is the main docker image. It is used to run the gazebo simulation and all the robot navigation stack

 - `docker_ros_noetic` contains the dockerfile that builds the ROS noetic docker image. This image is used to run the deep learning prediction. We can connect a container running on this image to the main container (running on the melodic image). This container will recieve the lidar point clouds, perform deep predictions, and publish the classifications. The main container will use this classifications

 
# Usage
## Installation
Clone this repository and the source code for the simulator. We also create a folder to store the experimental data after each run of the simulator.

```bash
cd ~
git clone https://github.com/utiasASRL/MyhalSimulator
git clone https://github.com/utiasASRL/MyhalSimulator-docker
mkdir -p Myhal_Simulation/simulated_runs
```

## Build the docker images
Execute `/docker_build.sh` to build either the `docker_ros_melodic` or the `docker_ros_noetic` docker images. 

```bash
cd MyhalSimulator-docker/ROS-Dockerfiles/docker_ros_melodic/
./docker_melodic.sh
``` 

## Check the volumes paths
Some docker volume local paths are hardcoded. This can lead to errors when the docker image try to access the volumes. To solve this, you should modify the local volume paths to match your file structure. 

For example, here in `/MyhalSimulator-docker/melodic_docker.sh`:

```
# Volumes (modify with your own path here)
volumes="-v /YOUR_PATH_TO_THE_SIMULATOR_CODE/MyhalSimulator:/home/$USER/catkin_ws \
-v /YOUR_PATH_TO_THE_SIMULATION_FOLDER/MyHal_Simulation/simulated_runs:/home/$USER/Myhal_Simulation "
```

In order for the simulator to be able to run with `docker_ros_melodic` image, the volume paths must be corrected in `MyhalSimulator-docker/melodic_docker.sh` and in `MyhalSimulator-docker/classification_test.sh`.

## (Optional) Remove the --gpus flags
?

 
# Set up the development environment
## Compiling the simulator in the container

Install [Visual Studio Code (vscode)](https://code.visualstudio.com/download) and its extentions **Docker** and **Remote-Containers**.

We will set up vscode to work inside a container built on our image `docker_ros_melodic`. 
Open vscode: 'Files' > 'Open worspace' and navigate to `/MyhalSimulator/melodic-TourGuide.code-workspace`.


The `.devcontainer/devcontainer.json` give vscode information about which image to build a container from and the extensions that should be downloaded in the containerized vscode environment.

Some information is hardcoded and should be modified. You should replace the `USER` flags with your system username, and modify the paths for `workspaceMount`, `workspaceFolder` and `"mounts":`
```
{
	"image": "docker_ros_melodic_USER",
	
    "workspaceMount": "source=/home/USER/MyhalSimulator,target=/home/USER/catkin_ws,type=bind,consistency=cached",
    "workspaceFolder": "/home/USER/catkin_ws",
    "mounts": [
      "source=/home/USER/Myhal_Simulation,target=/home/USER/Myhal_Simulation,type=bind,consistency=cached"
          ],
	"extensions": [
		"ms-vscode.cpptools",
		"twxs.cmake",
		"ms-vscode.cmake-tools",
		"ms-azuretools.vscode-docker",
		"ms-toolsai.jupyter",
		"ms-python.python",
		"ms-iot.vscode-ros",
		"redhat.vscode-xml",
		"dotjoshjohnson.xml"
	]
}
```

## Build / Rebuild the container environment
Now that the simulator files are ready in vscode, we can build the containerized vscode environment. 

In vscode, press `F1` to open the command editor, and type `Remote-Containers: Rebuild containers...`
If this is the first time you build the container, you might have to chose `Remote-Containers: Open folder in containers...`

## Build the simulator in the containerized environment
Press `ctrl+B` to build the simulator in the container. 
Your development environment is now ready!


# Testing the simulator
Run the following command to test the simulator with the `docker_ros_melodic` image:

```bash
cd ~/MyhalSimulator-docker/
./melodic_docker.sh -c "./master.sh -ve -m 2 -t A_tour -p Sc1_params"
```


# Scripts description
## Run Files

Filename | Description 
--- | --- 
`melodic_docker.sh` | Starts a container on the `docker_ros_melodic` image. This is the main file to start the simulation with a robot performing a tour (see MyhalSimulator repo for details). Tip: you can use this as is to start a container and attach it to a Visual Studio Code workspace.
`noetic_docker.sh` |  Start a container on the `docker_ros_noetic` image. (Same tip with vscode)
`classification_test.sh` | Start two containers on `docker_ros_melodic` and  `docker_ros_noetic` images. This script is used in the same way as `melodic_docker.sh` but only if we need deep network predictions.
`classification_test_2.sh` | Same as above but the two containers are started in a different order. Ignore this one


## Run multiple expriments
Filename | Description 
--- | --- 
`multi_tours.sh` | Runs multiple experiments with different parameters. Customize this file as you want for your own experiments
`nohup_multi_tours.sh` | Runs the `multi_tours.sh` in nohup mode so that you can close your ssh session and let the code run on the remote machine



## Debug scripts
Filename | Description 
--- | --- 
`connect_to_container.sh` | Open a Bash terminal inside the container)
`root_in_container.sh` | Open a root Bash terminal inside the container **Use with caution**
`dashboard_docker.sh` | Old file - ignore



To avoid ROS master conflicts when running multiple ROS containers on the same machine, the running scripts will incremement a local variable called `ROSPORT`. If not initially set, it will default to 1100. `export ROSPORT=<value>` will be appended to your ~/.bashrc file, over-writing a previous `export ROSPORT` statement if it is there. 

To ensure that the enviroment variable is changed in your local terminal, either run the script with `source melodic_docker.sh`, or after running a script use `source ~/.bashrc`.

### Melodic and Noetic Flags

-d, if set it will run the container in detached mode

-c [arg], will run the argument as a command in the container 

For example calling `source melodic_docker.sh -c "catkin build" -d` will run `catkin build` in a detached ROS melodic docker container.
