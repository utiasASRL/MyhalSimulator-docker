#FROM nvcr.io/nvidia/cuda:10.1-cudnn7-runtime
FROM nvcr.io/nvidia/cudagl:10.1-devel-ubuntu18.04

RUN apt update
RUN apt upgrade -y --no-install-recommends
RUN DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y --no-install-recommends
RUN apt update
RUN apt-get install gcc g++ python python-pip -y --no-install-recommends
RUN apt-get install gedit -y --no-install-recommends
RUN apt-get update
RUN apt-get install firefox -y --no-install-recommends
RUN apt-get install wget -y --no-install-recommends
RUN apt-get install git -y --no-install-recommends
RUN apt-get install xvfb -y --no-install-recommends   
RUN apt-get install vim -y --no-install-recommends
RUN pip install --upgrade pip
RUN pip install setuptools
RUN pip install numpy matplotlib 

RUN apt update
RUN apt install curl gnupg2 lsb-release -y --no-install-recommends
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt update
RUN apt install ros-melodic-desktop-full -y --no-install-recommends

RUN apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y --no-install-recommends
RUN rosdep init
RUN rosdep update

RUN apt-get install python-catkin-tools -y --no-install-recommends
RUN apt-get install ros-melodic-velodyne* -y --no-install-recommends
RUN apt-get install ros-melodic-jackal* -y --no-install-recommends
RUN apt-get install ros-melodic-pointcloud-to-laserscan -y --no-install-recommends
RUN apt-get install ros-melodic-rgbd-launch -y --no-install-recommends
RUN apt-get install ros-melodic-range-sensor-layer -y --no-install-recommends
RUN apt-get install ros-melodic-openni2* -y --no-install-recommends
RUN apt-get install ros-melodic-octomap* -y --no-install-recommends
RUN apt-get install ros-melodic-ros-control -y --no-install-recommends
RUN apt-get install ros-melodic-tf2 -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-py -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-kdl -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-ros -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-msgs -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-eigen -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-sensor-msgs -y --no-install-recommends
RUN apt-get install ros-melodic-tf2-geometry-msgs -y --no-install-recommends
RUN apt-get install ros-melodic-people-msgs -y --no-install-recommends
RUN apt-get install ros-melodic-people-velocity-tracker -y --no-install-recommends
RUN apt-get install ros-melodic-navigation* -y --no-install-recommends
RUN apt-get install ros-melodic-people-msgs -y --no-install-recommends
RUN apt-get install ros-melodic-social-navigation-layers -y --no-install-recommends
RUN apt-get install ros-melodic-teleop-twist-keyboard -y --no-install-recommends
#RUN apt-get update && apt-get install -y libgazebo9-dev
RUN apt-get install -y gnome-core --no-install-recommends
RUN apt-get install -y mesa-utils --no-install-recommends

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
RUN apt update
RUN apt upgrade -y --no-install-recommends

RUN apt-get install psmisc -y --no-install-recommends
RUN apt-get install ros-melodic-ros-numpy -y --no-install-recommends
RUN pip install plyfile scipy jupyterlab
RUN apt-get install python-tk ipython -y --no-install-recommends
RUN pip install psutil 
RUN pip install tabulate 
RUN apt-get install ffmpeg -y --no-install-recommends
RUN apt-get install xdg-utils -y --no-install-recommends
RUN apt-get install vim-gtk -y --no-install-recommends
RUN pip install moviepy

ARG username0=bag
ARG userid0=1085
RUN groupadd -g 1090 myhal_sim
RUN groupadd -g 1001 raid
RUN useradd -ms /bin/bash -u $userid0 $username0
RUN adduser $username0 myhal_sim
RUN adduser $username0 raid
RUN adduser $username0 root
RUN echo $username0':Ahsheel7' | chpasswd
USER $username0
WORKDIR /home/$username0/catkin_ws

#RUN echo "source /home/$username0/catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/home/$username0/catkin_ws/devel/lib" >> ~/.bashrc
RUN echo "export USER=$username0" >> ~/.bashrc

ENV ROS_DISTRO melodic
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV USER=$username0

# nvidia-docker hooks
#LABEL com.nvidia.volumes.needed="nvidia_driver"
#ENV PATH /usr/local/nvidia/bin:${PATH}
#ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

COPY --chown=$username0 entrypoint.sh /home/entrypoint.sh
RUN ipython profile create
COPY startup.py /home/$username0/.ipython/profile_default/startup/startup.py
ENTRYPOINT ["/home/entrypoint.sh"]
CMD ["bash"]

