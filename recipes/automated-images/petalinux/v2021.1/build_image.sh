#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Uses: Dockerfile
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 6/24/2021
#
# Source base image configuration
#source ../../../base-images/ubuntu-20.04.1/include/configuration.sh
source ../../../base-images/ubuntu-18.04.5/include/configuration.sh
# Source user image configuration
#source ../../../user-images/v2021.1/ubuntu-20.04.1-user/include/configuration.sh
source ../../../user-images/v2021.1/ubuntu-18.04.5-user/include/configuration.sh
# Source tool image configuration
source include/configuration.sh

# Set the Docker File for Petalinux
DOCKER_FILE_NAME=Dockerfile

# define options
function show_opts {
	echo "Syntax:"
	echo "-------"
	echo "${0} --<option>"
	echo ""
	echo "Valid Options:"
	echo "--------------"
	echo "  --debug"
	echo ""
	echo "		Enable debug output"
	echo ""
	echo " --help"
	echo ""
	echo "      display this syntax help"
	echo ""
}

# Init command ling argument flags
FLAG_BUILD_DEBUG=0 # Enable extra debug messages

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
			shift
			;;
		--help) # display syntax
			show_opts
			exit 0
			;;
		-*|--*=) # unsupported flags
			echo "ERROR: Unsupported option $1" >&2
			show_opts
			exit 1
			;;
		*) # all other parameters pass through
			PARAMS="$PARAMS $1"
			shift
			;;
	esac
done

# reset positional arguments
eval set -- "$PARAMS"

# Grab Start Time
DOCKER_BUILD_START_TIME=`date`

# Check that dependencies are not symbolic links, but actual files
# Docker won't be able to user files during build that are linked
# Because the actual file resides outside of the 'context' of the
# docker build.  This script will present an error when
# a symbolically linked dependency is encountered.

# Test for dependencies in order used
# 1. Base OS Image (i.e. Ubuntu:18.04.1)
# 2. Configurations (i.e. Keyboard, etc..)
# 3. Xilinx Tool Installers
# 4. Xilinx Tool Batch Mode Install Configuration Files

echo "-----------------------------------"
echo "Checking for dependencies..."
echo "-----------------------------------"

# Check for existing ubuntu user image:
if [[ "$(docker images -q $DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION 2> /dev/null)" == "" ]]; then
  # create the docker base image
  	echo "Base user image [missing] ("$DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION")"
 	exit $EX_OSFILE
else
	echo "Base user image [found] ("$DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION")"
fi

# Check for dependency files in the build context
# Since these builds use WGET instead of COPY or ADD
# files links within the build context can point outside
# the context and they will get transferred just fine.

# Check for Xilinx MALI binaries
if [ $DOCKER_BUILD_INCLUDE_XLNX_MALI -ne 0 ]; then
	if [ -f $XLNX_MALI_BINARY ] || [ -L $XLNX_MALI_BINARY ]; then
		echo "Xilinx MALI Binaries: [Good] "$XLNX_MALI_BINARY
	else
		echo "ERROR: Xilinx MALI Binaries: [Missing] "$XLNX_MALI_BINARY
		exit $EX_OSFILE
	fi
fi

# Check for Xilinx Petalinux Installer
if [ -f $XLNX_PETALINUX_INSTALLER ] || [ -L $XLNX_PETALINUX_INSTALLER ]; then
	echo "Xilinx Petalinux Installer: [Good] "$XLNX_PETALINUX_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx Petalinux Installer: [Missing] "$XLNX_PETALINUX_INSTALLER
	exit $EX_OSFILE
fi

# Create docker folder
echo "-----------------------------------"
echo "Docker Build Context (Working)..."
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

cd $DOCKER_BUILD_WORKING_DIR

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "DOCKER_INSTALL_DIR="$DOCKER_INSTALL_DIR
echo "DOCKER_BUILD_WORKING_DIR="$DOCKER_BUILD_WORKING_DIR
echo "-----------------------------------"

# Launch a dummy python http server
# This allows the use of WGET instead of COPY to add external files to the docker image for installation purposes
# This reduces the overall size of the resulting image
echo "-----------------------------------"
echo "Launching Python HTTP Server..."
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

# Launch python3 http server ip address and capture process id
python3 -m http.server & SERVER_PID=$!
SERVER_IP=`ifconfig docker0 | grep 'inet\s' | awk '{print $2}'`

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Set the Install Server URL
INSTALL_SERVER_URL="${SERVER_IP}:8000"
echo "SERVER_IP="$SERVER_IP
echo "SERVER_PID="$SERVER_PID
echo "-----------------------------------"

#Build the docker image
echo "-----------------------------------"
echo "Building the Docker Image..."
echo "-------------------------------"
echo "DOCKER_CACHE="$DOCKER_CACHE
echo "DOCKER_FILE_NAME="$DOCKER_FILE_NAME
echo "DOCKER_FILE_STAGE="$DOCKER_FILE_STAGE
echo "DOCKER_IMAGE="$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_VERSION
echo "DOCKER_INSTALL_DIR="$DOCKER_INSTALL_DIR
echo "INSTALL_SERVER_URL="$INSTALL_SERVER_URL
echo "-----------------------------------"
echo "Arguments..."
echo "-----------------------------------"
echo "	--build-arg USER_ACCT=\"${USER_ACCT}\""
echo " 	--build-arg HOME_DIR=\"${HOME_DIR}\""
echo " 	--build-arg XLNX_INSTALL_LOCATION=\"${XLNX_INSTALL_LOCATION}\""
echo "  --build-arg DOCKER_BUILD_INCLUDE_XLNX_MALI=\"${DOCKER_BUILD_INCLUDE_XLNX_MALI}\""
echo "  --build-arg XLNX_MALI_BINARY=\"${XLNX_MALI_BINARY}\""
echo " 	--build-arg INSTALL_SERVER_URL=\"${SERVER_IP}:8000\""
echo " 	--build-arg XLNX_PETALINUX_INSTALLER=\"${XLNX_PETALINUX_INSTALLER}\""
echo "  --build-arg XLNX_PETALINUX_AUTOINSTALL_SCRIPT=\"${XLNX_PETALINUX_AUTOINSTALL_SCRIPT}\""
echo "  --build-arg XLNX_PETALINUX_INSTALL_DIR=\"${XLNX_PETALINUX_INSTALL_DIR}\""
echo "  --build-arg BUILD_DEBUG=\"${FLAG_BUILD_DEBUG}\""
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg USER_ACCT="${USER_ACCT}" \
 	--build-arg HOME_DIR="${HOME_DIR}" \
 	--build-arg XLNX_INSTALL_LOCATION="${XLNX_INSTALL_LOCATION}" \
 	--build-arg DOCKER_BUILD_INCLUDE_XLNX_MALI="${DOCKER_BUILD_INCLUDE_XLNX_MALI}" \
 	--build-arg XLNX_MALI_BINARY="${XLNX_MALI_BINARY}" \
 	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
 	--build-arg XLNX_PETALINUX_INSTALLER="${XLNX_PETALINUX_INSTALLER}" \
 	--build-arg XLNX_PETALINUX_AUTOINSTALL_SCRIPT="${XLNX_PETALINUX_AUTOINSTALL_SCRIPT}" \
 	--build-arg XLNX_PETALINUX_INSTALL_DIR="${XLNX_PETALINUX_INSTALL_DIR}" \
 	--build-arg BUILD_DEBUG="${FLAG_BUILD_DEBUG}" \
  	$DOCKER_INSTALL_DIR

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Shut down the python3 http server
echo "-----------------------------------"
echo "Shutting down Python HTTP Server..."
echo "-----------------------------------"
echo "Killing process ID "$SERVER_PID
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

kill $SERVER_PID

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Grab End Time
DOCKER_BUILD_END_TIME=`date`
# Docker Image Build Complete
echo "-----------------------------------"
# Show docker images
docker image ls -a $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
echo "-----------------------------------"
echo "Image Build Complete..."
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
