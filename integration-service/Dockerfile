FROM ubuntu:20.04

#time zone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

#apt integration service basic dependencies
RUN apt-get update &&  apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  wget && rm -rf /var/lib/apt/lists/*
  
#pip integration service basic dependencies  
RUN python3 -m pip install -U \
  colcon-common-extensions 

#apt integration service basic dependencies
RUN apt-get update && apt-get install -y \
  libyaml-cpp-dev \
  libboost-program-options-dev && rm -rf /var/lib/apt/lists/*

# Fast DDS System Handle  
ADD eProsima_Fast-DDS-2.3.0-Linux.tgz /opt/eProsima_Fast-DDS-2.3.0
RUN cd /opt/eProsima_Fast-DDS-2.3.0 && ./install.sh
 
# Fiware System Handle
RUN apt-get update &&  apt-get install -y \
  libasio-dev \
  libcurlpp-dev \
  libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*
  
RUN mkdir ~/is-workspace && cd ~/is-workspace && git clone https://github.com/eProsima/Integration-Service.git src/Integration-Service --recursive

RUN cd ~/is-workspace && git clone https://github.com/eProsima/FastDDS-SH.git src/FastDDS-SH
RUN cd ~/is-workspace && git clone https://github.com/eProsima/FIWARE-SH.git src/FIWARE-SH

RUN python3 -m pip install -U \
  pytest-repeat \
  pytest-rerunfailures \
  pytest 


RUN cd ~/is-workspace && colcon build

#todo ip name of orion context broker
#todo create the entity fastdds
#todo create subscription
#todo extend solution to all the variables we want to add.

ADD config.yaml /root/is-workspace



#CMD ["/bin/bash", "-c", "source /root/is-workspace/install/setup.bash;integration-service /root/is-workspace/config.yaml"]



