# Dockerfiles and run files used for the Myhal Simulator project
# Docker images description

Two docker image folders are provided: `docker_ros_melodic` and `docker_ros_noetic`.

 - `docker_ros_melodic` contains the dockerfile that builds the ROS melodic docker image. This is the main docker image. It is used to run the gazebo simulation and all the robot navigation stack

 - `docker_ros_noetic` contains the dockerfile that builds the ROS noetic docker image. This image is used to run the deep learning prediction. We can connect a container running on this image to the main container (running on the melodic image). This container will recieve the lidar point clouds, perform deep predictions, and publish the classifications. The main container will use this classifications

 
# Installation
## Setup the files
Clone this repository and the source code for the simulator in an experiment folder of your choice that we call `EXP_ROOT_PATH` in the following. In addition, create a folder to store the experimental data after each run of the simulator.

```bash
cd [EXP_ROOT_PATH]
git clone https://github.com/utiasASRL/MyhalSimulator
git clone https://github.com/utiasASRL/MyhalSimulator-docker
mkdir -p Myhal_Simulation/simulated_runs
```

## Build the docker images
Execute `/docker_build.sh` to build either the `docker_ros_melodic` or the `docker_ros_noetic` docker images. Always use the provided scripts which set the right user and id for permissions.

```bash
cd MyhalSimulator-docker/ROS-Dockerfiles/docker_ros_melodic/
./docker_melodic.sh
``` 

## Check the volumes paths
The scripts running containers with the images you just built use volumes linking the implementation folder and the data folder to the containers' filesystems. The paths to these volumes are hardcoded and need to be modified to match tour file structure. 

In `melodic_docker.sh` and `classification_test.sh`, modify the follwing lines:

```
# Volumes (modify with your own path here)
volumes="-v /EXP_ROOT_PATH/MyhalSimulator:/home/$USER/catkin_ws \
-v /EXP_ROOT_PATH/Myhal_Simulation/simulated_runs:/home/$USER/Myhal_Simulation "
```

## Run with nvidia gpu (Optional)

If you have a nvidia gpu, the simulator can use it. First make sure you have installed the nvidia drivers for your card. Then you need to  [install nvidia-docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker).

Now, you should be able to uncomment the following line in `melodic_docker.sh`:

```bash
# Running on gpu (Uncomment to enable gpu)
# docker_args="${docker_args} --gpus all "
```

## Compile simulator with command line
You can compile the simulator in command line, but we advise to use the developpement environment below if you plan to make modifications to the code.

```bash
cd /EXP_ROOT_PATH/MyhalSimulator-docker/
./melodic_docker.sh -c "./catkin_maker.sh"
```

# Testing the simulator
Run the following command to test the compiled simulator with the `docker_ros_melodic` image:

```bash
cd /EXP_ROOT_PATH/MyhalSimulator-docker/
./melodic_docker.sh -c "./master.sh -ve -m 2 -t A_tour -p Sc1_params"
```

 
# Set up a development environment

## Using VSCode in a dev container

With VSCode, you can develop your code directly within a container. This way, you can use nice code features like auto-completions, variable types, etc.  

Install [Visual Studio Code (vscode)](https://code.visualstudio.com/download) and open it. In the software, you can now install the extentions **Docker** and **Remote-Containers**.

We will set up vscode to work inside a container built on our image `docker_ros_melodic`. Open vscode: 'Files' > 'Open worspace' and navigate to `/EXP_ROOT_PATH/MyhalSimulator/melodic-TourGuide.code-workspace`.

The `.devcontainer/devcontainer.json` gives vscode information about which image to build a container from and the extensions that should be downloaded in the containerized vscode environment. In the same way as `melodic_docker.sh`, it also sets volumes but with relative path so you should not need to modify anything in it.


## Build / Rebuild the container environment
Now that the simulator files are ready in vscode, we can build the containerized vscode environment. 

In vscode, press `F1` to open the command editor, and type `Remote-Containers: Rebuild containers...`
If this is the first time you build the container, you might have to chose `Remote-Containers: Open folder in containers...`

## Compiling the simulator in the container

VSCode provides automated tasks, for example for compilation. These tasks are defined in `.vscode/tasks.json`. As you can see, the **catkin_build** task is already defined in the provided tasks file.

Just press `ctrl+maj+b` to compile the simulator code (much simpler than using the command line above).


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

For example calling `./melodic_docker.sh -c "./catkin_maker.sh" -d` will run the compile command `"./catkin_maker.sh"` in a detached ROS melodic docker container.
