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

volumes="-v /home/$USER/Experiments/2-MyhalSim/MyhalSimulator:/home/$USER/catkin_ws \
-v /home/$USER/Experiments/2-MyhalSim/Simulation:/home/$USER/Myhal_Simulation "


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

other_args="-v $XSOCK:$XSOCK:rw \
    -v $XAUTH:$XAUTH:rw \
    -v /home/$USER/.Xauthority:/home/$USER/.Xauthority \
    --net=host \
	-e XAUTHORITY=${XAUTH} \
    -e DISPLAY=$DISPLAY \
    -e ROS_MASTER_URI=http://$HOSTNAME:$rosport \
    -e GAZEBO_MASTER_URI=http://$HOSTNAME:$gazport \
    -e ROSPORT=$rosport "


container_name="$USER-melodic-$ROSPORT"


if [ "$detach" = true ] ; then
    docker run -d --gpus all -it --rm --shm-size=64g \
    $volumes \
    $other_args \
    --name $container_name \
    docker_ros_melodic_$USER \
    $command 
else

    if [ "$nohup" = true ] ; then

        docker run --gpus all -i --rm --shm-size=64g \
        $volumes \
        $other_args \
        --name $container_name \
        docker_ros_melodic_$USER \
        $command 

    else

        nvidia-docker run --gpus all -it --rm --shm-size=64g --runtime=nvidia \
        $volumes \
        $other_args \
        --name $container_name \
        docker_ros_melodic_$USER \
        $command 
    fi
fi

echo "Final Sourcing ..."
source ~/.bashrc


