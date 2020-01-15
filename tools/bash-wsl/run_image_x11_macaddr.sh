#!/bin/bash
# Run a xilinx tool docker image as a container on Docker for Windows
# using Docker Compose through Windows Subsystem for Linux
#
# This version is maintained as an example of using volumes
# in the docker container with WSL and Docker for Windows
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 1/15/2020
#
# Note: MAC ADDRESS ASSIGNMEMT
# ============================
# - There are 4 "Locally Administered" MAC address ranges you can assign
# - x2:xx:xx:xx:xx:xx
# - x6:xx:xx:xx:xx:xx
# - xA:xx:xx:xx:xx:xx
# - xE:xx:xx:xx:xx:xx

# Process Command line arguments
if [[ $# -ne 3 ]]; then
	echo "${@}"
	echo "This scripts requires exactly 3 arguments.\n"
	echo "Syntax:"
	echo "${0} <docker_image_name> <docker_container_name> <docker_container_macaddr>"
	echo "Where:"
	echo "<docker_image_name> is a valid, existing docker image (docker image ls)"
	echo "<docker_container_name> is the name to use when creating the new working container\n"
	echo "<docker_container_macaddr> is the MAC Address to use for the container network adapter\n"
	echo " - macaddr assigment range suggestions"
	echo " - use a locally addressable range, such as"
	echo "		- x2:xx:xx:xx:xx:xx"
	echo "      - x6:xx:xx:xx:xx:xx"
	echo "      - xA:xx:xx:xx:xx:xx"
	echo "      - xE:xx:xx:xx:xx:xx"
	echo " "
	echo "Examples:"
	echo "${0} xilinx-petalinux:v2018.3 xilinx_petalinux 00:00:00:00:00:00"
	echo "${0} xilinx-vivado:v2018.3 xilinx_vivado 00:00:00:00:00:00"
	echo "${0} xilinx-yocto:v2018.3 xilinx_yocto 00:00:00:00:00:00"
	echo " "
	echo "Here are your valid docker images:"
	echo "----------------------------------"
	docker image ls
	echo "Here are your existing docker containers:"
	echo "-----------------------------------------"
	docker ps -a
	exit 1
else
	echo "DOCKER_IMAGE_NAME: $1"
	DOCKER_IMAGE_NAME=$1
	echo "DOCKER_CONTAINER_NAME: $2"
	DOCKER_CONTAINER_NAME=$2
	echo "DOCKER_CONTAINER_MACADDR: $3"
	DOCKER_CONTAINER_MACADDR=$3
fi

# Grab the local ethernet IP address
SERVER_IP=`ifconfig eth1 | grep 'inet\s' | awk '{print $2}'` 

# Define the VcXsrv display variable
DISPLAY=":0.0"


# Notes on docker run options used:
# ---------------------------------
#
# '-v /mnt/d/srv/sstate-mirrors:/srv/sstate-mirrors'
# - share petalinux pre-downloaded sstate-cache mirror on the host system
#
# '-v /mnt/d/srv/tftpboot:/tftpboot'
# - provides a tftpboot folder for the container (and installed Xilinx tools) but files
# - actually reside on the host filesystem where the TFTP server is actually installed and running
#
# '-v /mnt/d/srv/software/xilinx:/srv/software'
# - share xilinx software downloaded on host system, including bsps, trd bundles, etc...
#
# '-v /mnt/d/srv/shared:/srv/shared'
# - generic share folder with host for temporary file sharing between container and host OS
#
# '-e DISPLAY=$SERVER_IP$DISPLAY'
# - share the host system's DISPLAY definition, which allows X-windows sessions to use the host system display
#
# `--mac-address`
# - set the container's MAC Address, which is associated with the Xilinx tool license
#
# `--user`
# - run the container as the non-root user.  This is xilinx:xilinx for all images/containers in this repo.
#
# '-h $DOCKER_CONTAINER_NAME'
# - set the container hostname (for networking and terminal identification purposes)
# - this makes it easier to associate xterm sessions with a running container


# docker run \
# 	--name $DOCKER_CONTAINER_NAME \
# 	-h $DOCKER_CONTAINER_NAME \
#     -v 'd:\xilinx\srv\sstate-mirrors':/srv/sstate-mirrors \
#     -v 'd:\xilinx\srv\sstate-cache':/srv/sstate-cache \
#     -v 'd:\xilinx\srv\tftpboot':/tftpboot \
#     -v 'd:\xilinx\srv\software':/srv/software \
#     -v 'd:\xilinx\srv\hardware_definitions':/srv/ \
# 	-e DISPLAY=$SERVER_IP$DISPLAY \
# 	--mac-address $DOCKER_CONTAINER_MACADDR \
# 	--user 1000:1000 \
# 	-itd $DOCKER_IMAGE_NAME \
# 	/bin/bash

docker run \
	--name $DOCKER_CONTAINER_NAME \
	-h $DOCKER_CONTAINER_NAME \
	-v /d/xilinx/srv/sstate-mirrors:/srv/sstate-mirrors \
	-v /d/xilinx/srv/tftpboot:/tftpboot \
	-v /d/xilinx/srv/software:/srv/software \
	-v /d/xilinx/srv/shared:/srv/shared \
	-e DISPLAY=$SERVER_IP$DISPLAY \
	--mac-address $DOCKER_CONTAINER_MACADDR \
	--user 1000:1000 \
	-itd $DOCKER_IMAGE_NAME \
	/bin/bash