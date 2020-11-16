# A collection of dockerfiles for ROS

## Run Files

To avoid ROS master conflicts when running multiple ROS containers on the same machine, all of the scripts in `run_scripts/` will incremement a local variable called `ROSPORT`. If not initially set, it will default to 1100. `export ROSPORT=<value>` will be appended to your ~/.bashrc file, over-writing a previous `export ROSPORT` statement if it is there. 
To ensure that the enviroment variable is changed in your local terminal, either run the script with `source melodic_docker.sh`, or after running a script use `source ~/.bashrc`.

### Melodic and Noetic Flags

-d, if set it will run the container in detached mode

-c [arg], will run the argument as a command in the container 

For example calling `source melodic_docker.sh -c "catkin build" -d` will run `catkin build` in a detached ROS melodic docker container.

