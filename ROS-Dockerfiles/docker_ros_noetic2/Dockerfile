#FROM osrf/ros:noetic-desktop-full
#FROM vistart/cuda:10.1-cudnn7-runtime-ubuntu20.04
FROM nvcr.io/nvidia/cudagl:11.0-devel-ubuntu20.04


# Setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# Setup environment
RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends
RUN DEBIAN_FRONTEND=noninteractive

# Install preliminary packages
RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends
RUN apt-get install gcc g++ python3 python3-pip python3-dev -y --no-install-recommends
RUN apt-get install gedit firefox wget git xvfb vim nano -y --no-install-recommends
RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends

# Install preliminary python packages
RUN pip3 install --upgrade pip
RUN pip3 install setuptools
RUN pip3 install numpy scikit-learn matplotlib PyYAML

# Install PyTorch
RUN pip3 install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html


# Install QT
RUN pip3 install PyQt5
RUN apt-get install pyqt5-dev-tools pyqt5-dev -y --no-install-recommends


# Install ROS 
RUN apt-get update
RUN apt-get install curl gnupg2 lsb-release -y --no-install-recommends
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -

RUN apt-get update
RUN apt-get install ros-noetic-desktop-full -y --no-install-recommends

# Install ROS packages
RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y --no-install-recommends
RUN rosdep init
RUN rosdep update

RUN apt-get install python3-catkin-tools -y --no-install-recommends
RUN apt-get install ros-noetic-velodyne* -y --no-install-recommends
# RUN apt-get install ros-noetic-jackal* -y --no-install-recommends
RUN apt-get install ros-noetic-pointcloud-to-laserscan -y --no-install-recommends
RUN apt-get install ros-noetic-rgbd-launch -y --no-install-recommends
# RUN apt-get install ros-noetic-range-sensor-layer -y --no-install-recommends
RUN apt-get install ros-noetic-openni2* -y --no-install-recommends
RUN apt-get install ros-noetic-octomap* -y --no-install-recommends
RUN apt-get install ros-noetic-ros-control -y --no-install-recommends
RUN apt-get install ros-noetic-tf2* -y --no-install-recommends
RUN apt-get install ros-noetic-people-msgs -y --no-install-recommends
RUN apt-get install ros-noetic-people-velocity-tracker -y --no-install-recommends
RUN apt-get install ros-noetic-navigation* -y --no-install-recommends
# RUN apt-get install ros-noetic-social-navigation-layers -y --no-install-recommends
RUN apt-get install ros-noetic-teleop-twist-keyboard -y --no-install-recommends

# Additionnal packages
RUN apt-get install -y gnome-core mesa-utils --no-install-recommends

# Install Gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends

# Additionnal packages
RUN apt-get install psmisc -y --no-install-recommends
RUN apt-get install ros-noetic-ros-numpy -y --no-install-recommends
RUN pip install plyfile scipy jupyterlab

# Install gazebo
RUN apt-get install gazebo11
RUN apt-get install libgazebo11-dev -y --no-install-recommends
RUN apt-get install ros-noetic-gazebo* -y --no-install-recommends

# Additionnal packages
RUN apt-get install python3-tk -y --no-install-recommends
RUN pip3 install ipython
RUN pip install psutil 
RUN pip install tabulate 
RUN apt-get install ffmpeg -y --no-install-recommends
RUN apt-get install xdg-utils -y --no-install-recommends
RUN apt-get install vim-gtk -y --no-install-recommends
RUN pip install moviepy

# RUN apt-get install libnvidia-gl-430:i386

# Setup user information
ARG username0=bag
ARG userid0=1085
RUN groupadd -g 1090 myhal_sim
RUN groupadd -g 1001 raid
RUN useradd -ms /bin/bash -u $userid0 $username0
RUN adduser $username0 myhal_sim
RUN adduser $username0 raid
RUN adduser $username0 root
RUN adduser $username0 sudo
RUN echo $username0':Ahsheel7' | chpasswd
USER $username0
WORKDIR /home/$username0/catkin_ws


RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#RUN echo "source /home/$username0/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "export USER=$username0" >> ~/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/home/$username0/catkin_ws/devel/lib" >> ~/.bashrc

# nvidia-docker hooks
#LABEL com.nvidia.volumes.needed="nvidia_driver"
#ENV PATH /usr/local/nvidia/bin:${PATH}
#ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

ENV ROS_DISTRO noetic
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV USER=$username0

COPY --chown=$username0 entrypoint.sh /home/entrypoint.sh
RUN ipython profile create
COPY startup.py /home/$username0/.ipython/profile_default/startup/startup.py
ENTRYPOINT ["/home/entrypoint.sh"]
CMD ["bash"]
