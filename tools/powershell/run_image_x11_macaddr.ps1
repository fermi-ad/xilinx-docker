# CONVERTED ORIGINAL BASH SCRIPT TO WINDOWS POWERSHELL SYNTAX
#!/bin/bash
# Run a xilinx docker image as a container
# 
#
# Maintainer:
# - Jason Moss (jason.moss@avnet.com)
# - Xilinx Applications Engineer, Embedded Software
#
# Created: 
# - 02/18/2019
#
# Note: MAC ADDRESS ASSIGNMEMT
#
# 4 "Locally Administered" MAC address ranges you can assign
# - x2:xx:xx:xx:xx:xx
# - x6:xx:xx:xx:xx:xx
# - xA:xx:xx:xx:xx:xx
# - xE:xx:xx:xx:xx:xx
#
########################################################################################
# Docker Script Debug Tracing
########################################################################################
#RUN_DEBUG=1 Turns shell command expansion on in Docker build scripts
#RUN_DEBUG=0 Turns shell expandion off in Docker build scripts
$RUN_DEBUG = 1

# Define the VcXsrv display variable
$DISPLAY = ":0.0"

# param (
#   [string]$DOCKER_IMAGE_NAME,
#   [string]$DOCKER_CONTAINER_NAME,
#   [string]$DOCKER_CONTAINER_MADADDR
# )

# Process Command line arguments
if ( $args.count -ne 3 ) {
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
  echo "    - x2:xx:xx:xx:xx:xx"
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
} else {
  $DOCKER_IMAGE_NAME=$args[ 0 ]
  echo "DOCKER_IMAGE_NAME: $DOCKER_IMAGE_NAME"
  $DOCKER_CONTAINER_NAME=$args[ 1 ]
  echo "DOCKER_CONTAINER_NAME: $DOCKER_CONTAINER_NAME"
  $DOCKER_CONTAINER_MACADDR=$args[ 2 ]
  echo "DOCKER_CONTAINER_MACADDR: $DOCKER_CONTAINER_MACADDR"
}

if ($BUILD_DEBUG -ne 0) {
  # Turn on debug tracing (this script)
  Set-PSDebug -Trace 1
}

# Determine the local IP Address# Get the ip address of the virtual ethernet adapter
$SERVER_IP = Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias 'vEthernet (Default Switch)'
$SERVER_IP = $SERVER_IP.IPAddress.ToString()

if ($BUILD_DEBUG -ne 0) {
  # Turn off debug tracing (this script)
  Set-PSDebug -Trace 0
}

echo "Setting DISPLAY=$SERVER_IP$DISPLAY"

# Enable sharing of x session
#xhost +

# Notes on docker run options used:
# ---------------------------------
#
# '-v d:\srv\sstate-mirrors:/srv/sstate-mirrors'
# - share petalinux pre-downloaded sstate-cache mirror on the host system
#
# '-v d:\srv\tftpboot:/tftpboot'
# - provides a tftpboot folder for the container (and installed Xilinx tools) but files
# - actually reside on the host filesystem where the TFTP server is actually installed and running
#
# '-v d:\srv\software\xilinx:/srv/software'
# - share xilinx software downloaded on host system, including bsps, trd bundles, etc...
#
# '-v d:\srv\shared:/srv/shared'
# - generic share folder with host for temporary file sharing between container and host OS
#
# '-e DISPLAY=$DISPLAY'
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

docker run `
   --name $DOCKER_CONTAINER_NAME `
   -h $DOCKER_CONTAINER_NAME `
   -v d:\xilinx\srv\sstate-mirrors:/srv/sstate-mirrors `
   -v d:\xilinx\srv\sstate-cache:/srv/sstate-cache `
   -v d:\xilinx\srv\tftpboot:/tftpboot `
   -v d:\xilinx\srv\software:/srv/software `
   -v d:\xilinx\srv\hardware_definitions:/srv/hardware_definitions `
   -v d:\xilinx\srv\shared:/srv/shared `
   -e DISPLAY=$SERVER_IP$DISPLAY `
   --mac-address $DOCKER_CONTAINER_MACADDR `
   --user 1000:1000 `
   -itd $DOCKER_IMAGE_NAME `
   /bin/bash