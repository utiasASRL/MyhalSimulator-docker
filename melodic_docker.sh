#!/bin/bash

echo ""
echo "Running ros-melodic docker. Remember you can set ROSPORT to a custom value"
echo ""

rosport=$ROSPORT
detach=false
nohup=false
command=""

while getopts dnc: option
do
case "${option}"
in
d) detach=true;;
n) nohup=true;;
c) command=${OPTARG};;
esac
done

if [ -n "$command" ]; then
  echo -e "Running command $command\n"
fi

if [[ -z "$ROSPORT" ]]; then
    echo "WARNING: didn't provide ROSPORT, setting it to 1100"
    export ROSPORT=1100
fi

last_line=$(tail -1 ~/.bashrc)
s=${last_line:0:14}
if [[ "$s" == "export ROSPORT" ]]; then
    sed -i '$d' ~/.bashrc
fi

echo "ROSPORT=$rosport"
gazport=$(($rosport+1))
export ROSPORT=$(($ROSPORT+2))
echo "export ROSPORT=$ROSPORT" >> ~/.bashrc


if [ "$detach" = true ] ; then
    docker run -d --gpus all -it --rm --shm-size=64g \
    -v /raid/Myhal_Simulation/Simulator/JackalTourGuide:/home/$USER/catkin_ws \
    -v /raid/Myhal_Simulation:/home/$USER/Myhal_Simulation \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/$USER/.Xauthority:/home/$USER/.Xauthority \
    --net=host \
    -e XAUTHORITY=/home/$USER/.Xauthority \
    -e DISPLAY=$DISPLAY \
    -e ROS_MASTER_URI=http://obelisk:$rosport \
    -e GAZEBO_MASTER_URI=http://obelisk:$gazport \
    -e ROSPORT=$rosport \
    --name "$USER-melodic-$ROSPORT" \
    docker_ros_melodic_$USER \
    $command 
else

    if [ "$nohup" = true ] ; then

        docker run --gpus all -i --rm --shm-size=64g \
        -v /raid/Myhal_Simulation/Simulator/JackalTourGuide:/home/$USER/catkin_ws \
        -v /raid/Myhal_Simulation:/home/$USER/Myhal_Simulation \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/$USER/.Xauthority:/home/$USER/.Xauthority \
        --net=host \
        -e XAUTHORITY=/home/$USER/.Xauthority \
        -e DISPLAY=$DISPLAY \
        -e ROS_MASTER_URI=http://obelisk:$rosport \
        -e GAZEBO_MASTER_URI=http://obelisk:$gazport \
        -e ROSPORT=$rosport \
        --name "$USER-melodic-$ROSPORT" \
        docker_ros_melodic_$USER \
        $command

    else

        docker run --gpus all -it --rm --shm-size=64g \
        -v /raid/Myhal_Simulation/Simulator/JackalTourGuide:/home/$USER/catkin_ws \
        -v /raid/Myhal_Simulation:/home/$USER/Myhal_Simulation \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/$USER/.Xauthority:/home/$USER/.Xauthority \
        --net=host \
        -e XAUTHORITY=/home/$USER/.Xauthority \
        -e DISPLAY=$DISPLAY \
        -e ROS_MASTER_URI=http://obelisk:$rosport \
        -e GAZEBO_MASTER_URI=http://obelisk:$gazport \
        -e ROSPORT=$rosport \
        --name "$USER-melodic-$ROSPORT" \
        docker_ros_melodic_$USER \
        $command
    fi
fi

echo "Final Sourcing ..."
source ~/.bashrc


