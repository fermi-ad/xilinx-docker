#!/bin/bash
# Run a xilinx tool docker image as a container
#	- Tested with images built from the following Docker recipes in this repository: 
#	# Vivado
#		- ../../recipes/vivado/v2018.3/Dockerfile
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 1/9/2019
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
	echo "DOCKER_CONTAINER_MACADDR: $d"
	DOCKER_CONTAINER_MACADDR=$3
fi

# Enable sharing of x session
xhost +

# Notes on docker run options used:
# ---------------------------------
# '-v /tmp/.X11-unix:/tmp/.X11-unix'
#
# '-v ~/.Xauthority:/home/xilinx/.Xauthority'
#	- required to launch X-based applications in the container and connect them to the host system
#
# '-v /xilinx/local/sstate-mirrors:/srv/sstate-mirrors'
#	- share petalinux pre-downloaded sstate-cache mirror on the host system
#
# '-v /xilinx/local/sstate-cache:/srv/sstate-cache'
#	- share petalinux/yocto working sstate-cache folder on the host system
#	- this keeps work product/temp files outside of the container that can be re-used
#
# '-v /srv/tftpboot:/tftpboot'
#	- provides a tftpboot folder for the container (and installed Xilinx tools) but files
#	- actually reside on the host filesystem where the TFTP server is actually installed and running
#
# '-v /srf/software/xilinx:/srv/software'
#	- share xilinx software downloaded on host system, including bsps, trd bundles, etc...
#
# '-v /srv/shared:/srv/shared'
#	- generic share folder with host for temporary file sharing between container and host OS
#
# '-v /srv/hardware_definitions:/srv/hardware_definitions'
#	- generic share folder with Vivado HDF design files that can be shared between containers
#	- Export HDF files from a Vivado container using this folder
#	- Import HDF files to a Petalinux container using this folder
#
# '-e DISPLAY'
#	- share the host system's DISPLAY definition, which allows X-windows sessions to use the host system display
#
# `--mac-address`
#	- set the container's MAC Address, which is associated with the Xilinx tool license
#
# `--user`
#	- run the container as the non-root user.  This is xilinx:xilinx for all images/containers in this repo.
#
# '-h $DOCKER_CONTAINER_NAME'
#	- set the container hostname (for networking and terminal identification purposes)
#	- this makes it easier to associate xterm sessions with a running container

docker run \
	--name $DOCKER_CONTAINER_NAME \
	-h $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /xilinx/local/sstate-mirrors:/srv/sstate-mirrors \
	-v /xilinx/local/sstate-cache:/srv/sstate-cache \
	-v /srv/tftpboot:/tftpboot \
	-v /srv/software/xilinx:/srv/software \
	-v /srv/hardware_definitions:/srv/hardware_definitions \
	-v /srv/shared:/srv/shared \
	-e DISPLAY=$DISPLAY \
	--mac-address $DOCKER_CONTAINER_MACADDR \
	--user 1000:1000 \
	-itd $DOCKER_IMAGE_NAME \
	/bin/bash