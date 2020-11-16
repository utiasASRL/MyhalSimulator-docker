#FROM osrf/ros:noetic-desktop-full
FROM vistart/cuda:10.1-cudnn7-runtime-ubuntu20.04

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt update
RUN apt upgrade -y --no-install-recommends
RUN DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y --no-install-recommends
RUN apt-get update
RUN apt-get install gcc g++ python3 python3-pip python3-dev -y --no-install-recommends
RUN apt-get install gedit -y --no-install-recommends
RUN apt-get update
RUN apt-get install firefox -y --no-install-recommends
RUN apt-get install wget -y --no-install-recommends
RUN apt-get install git -y --no-install-recommends
RUN apt-get install xvfb -y --no-install-recommends   
RUN apt-get install vim -y --no-install-recommends
RUN pip3 install --upgrade pip
RUN pip3 install setuptools
RUN pip3 install numpy scikit-learn matplotlib PyYAML
RUN pip3 install torch==1.5.1+cu101 torchvision==0.6.1+cu101 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install PyQt5
RUN apt install pyqt5-dev-tools pyqt5-dev -y --no-install-recommends

RUN apt update
RUN apt install curl gnupg2 lsb-release -y --no-install-recommends
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -

RUN apt-get update --fix-missing
RUN apt install ros-noetic-desktop-full -y --no-install-recommends


RUN apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y --no-install-recommends

RUN apt-get install ros-noetic-rgbd-launch -y --no-install-recommends
RUN apt-get install ros-noetic-openni2* -y --no-install-recommends
RUN apt-get install ros-noetic-octomap* -y --no-install-recommends
RUN apt-get install ros-noetic-ros-control -y --no-install-recommends
RUN apt-get install ros-noetic-tf2* -y --no-install-recommends
RUN apt-get install ros-noetic-navigation* -y --no-install-recommends
RUN apt-get install ros-noetic-gazebo* -y --no-install-recommends

RUN apt-get install python3-tk -y --no-install-recommends
RUN pip3 install ipython


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

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#RUN echo "source /home/$username0/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "export USER=$username0" >> ~/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/home/$username0/catkin_ws/src/myhal_simulator/models" >> ~/.bashrc
RUN echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/home/$username0/catkin_ws/devel/lib" >> ~/.bashrc

ENV ROS_DISTRO noetic
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV USER=$username0

COPY --chown=$username0 entrypoint.sh /home/entrypoint.sh
RUN ipython profile create
COPY startup.py /home/$username0/.ipython/profile_default/startup/startup.py
ENTRYPOINT ["/home/entrypoint.sh"]
CMD ["bash"]

