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
# Updated:
#   - 3/23/2020:  Add /dev:/dev mapping to container for access to JTAG
#   - 3/24/2020:  Add automatic CGROUP definition for container create to access /dev/ttyUSB*
#   - 9/22/2021:  Add '--cpus' switch to limit CPU Utilization of any container
#	- 9/23/2021:  Add '--memory' switch to limit physical memory use of any container
#   - 9/23/2021:  Do not add '--memory-swap' switch, default behavior use double --memory option
#    
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
if [[ $# -ne 4 ]]; then
	echo "${@}"
	echo "This scripts requires exactly 3 arguments.\n"
	echo "Syntax:"
	echo "${0} <docker_image_name> <docker_container_name> <docker_container_macaddr> <docker_container_cpulimit> <docker_container_memorylimit> <docker_container_swaplimit>"
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
	echo "<docker_container_cpulimit> is the maximum number of Host CPU threads the container can use\n"
#	echo "<docker_container_memorylimit> is the maximum amount of physical Host RAM the container can use\n"
#	echo "                               - valid suffixes:\n"
#	echo "                               - b=bytes, k=kilobytes, m=megabytes, g=gigabytes"
#	echo " "
#	echo "<docker_container_swaplimit> is the maximum amount of Host SWAP space the container can use\n"
	echo "Examples:"
	echo "${0} xilinx-petalinux:v2018.3 xilinx_petalinux 00:00:00:00:00:00 4"
	echo "${0} xilinx-vivado:v2018.3 xilinx_vivado 00:00:00:00:00:00 4"
	echo "${0} xilinx-yocto:v2018.3 xilinx_yocto 00:00:00:00:00:00 4"
	echo " "
	echo "Here are your valid docker images:"
	echo "----------------------------------"
	docker image ls
	echo "Here are your existing docker containers:"
	echo "-----------------------------------------"
	docker ps -a
	exit 1
else
	# Determine the CGROUP for /dev/ttyUSB* on the local host
	export DOCKER_TTYUSB_CGROUP=`ls -l /dev/ttyUSB* | sed 's/,/ /g' | awk '{print $5}' | head -n 1`
	echo "DOCKER_IMAGE_NAME: $1"
	DOCKER_IMAGE_NAME=$1
	echo "DOCKER_CONTAINER_NAME: $2"
	DOCKER_CONTAINER_NAME=$2
	echo "DOCKER_CONTAINER_MACADDR: $3"
	DOCKER_CONTAINER_MACADDR=$3
	echo "DOCKER_TTYUSB_CGROUP=$DOCKER_TTYUSB_CGROUP"
	DOCKER_CONTAINER_CPULIMIT=$4
	echo "DOCKER_CONTAINER_CPULIMIT: $4"
#	DOCKER_CONTAINER_MEMORYLIMIT=$5
#	echo "DOCKER_CONTAINER_MEMORYLIMIT: $5"
#	DOCKER_CONTAINER_SWAPLIMIT=$6
#	echo "DOCKER_CONTAINER_SWAPLIMIT: $6"
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
# '-v /xilinx:/xilinx'
#	- share all xilinx development related folders on host
#   - includes: 
#        - Petalinux: sstate-cache, sstate-mirrors, downloads
#        - Xilinx TRD designs, shared project folders accessible by all containers
#
# '-v /srv/tftpboot:/tftpboot'
#	- provides a tftpboot folder for the container (and installed Xilinx tools) but files
#	- actually reside on the host filesystem where the TFTP server is actually installed and running
#
# '-v /srv/software:/srv/software'
#	- share xilinx software downloaded on host system, including bsps, trd bundles, etc...
#
# '-v ~/repositories:/xilinx/local/shared/repositories'
#	- Git repositories in host user folder are shared with all containers
#   - This eliminates the need for duplicate clones/checkouts of GIT repos across containers
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
# 
# '-v /dev:/dev \'
#	- Share the /dev devices so Vitis/SDK has access to JTAG debugging connection

#	--memory=$DOCKER_CONTAINER_MEMORYLIMIT \
#	--cpus=$DOCKER_CONTAINER_CPULIMIT \

docker run \
	--name $DOCKER_CONTAINER_NAME \
	--cpus=$DOCKER_CONTAINER_CPULIMIT \
	--device-cgroup-rule "c $DOCKER_TTYUSB_CGROUP:* rwm" \
	-h $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v ~/repositories:/xilinx/local/shared/repositories \
	-v /xilinx:/xilinx \
	-v /srv/tftpboot:/srv/tftpboot \
	-v /srv/software:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address $DOCKER_CONTAINER_MACADDR \
	--user xilinx \
	-itd $DOCKER_IMAGE_NAME \
	/bin/bash