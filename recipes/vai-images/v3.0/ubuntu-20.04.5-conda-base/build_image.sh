#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Uses: Dockerfile.iso
#   - Uses: Dockerfile.base
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/2/2021
#
# Source base image configuration
source ../../../base-images/ubuntu-20.04.5/include/configuration.sh

# Source user image configuration
source include/configuration.sh

# Temporary Override of Docker File Stage
#DOCKER_FILE_STAGE=base_os_ubuntu-20.04.5-vai-cpu-base_v3.0

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
	echo "  --base"
	echo ""
	echo "      Generate docker image using Dockerfile.base"
	echo ""
	echo "  --iso"
	echo ""
	echo "      Generate docker image using Dockerfile.iso"
	echo "      This will override the use of the '--base' flag"
	echo ""
	echo " --help"
	echo ""
	echo "      display this syntax help"
	echo ""
}

# Init command ling argument flags
FLAG_BUILD_DEBUG=0 # Enable extra debug messages
FLAG_BASE_IMAGE=0 # Use the base release image
FLAG_ISO_IMAGE=0 # Use the iso release image

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
			shift
			;;
		--base) # Download the base release image
			FLAG_BASE_IMAGE=1
			echo "Set: FLAG_BASE_IMAGE=$FLAG_BASE_IMAGE"
			shift
			;;
		--iso) # Download the iso release image
			FLAG_ISO_IMAGE=1
			echo "Set: FLAG_ISO_IMAGE=$FLAG_ISO_IMAGE"
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

# Setup the docker image information
if [ $FLAG_ISO_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting iso image parameters."; fi
	DOCKER_FILE_NAME=Dockerfile.iso
	DOCKER_BASE_IMAGE=$BASE_OS_NAME-iso:$BASE_OS_VERSION
elif [ $FLAG_BASE_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting base image parameters."; fi
	DOCKER_FILE_NAME=Dockerfile.base
	DOCKER_BASE_IMAGE=$BASE_OS_NAME:$BASE_OS_VERSION
else
	echo "No base image type specified."
	show_opts
	exit $EX_OSFILE
fi

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
	echo " Docker Image Configuration"
	echo " --------------------"
	echo "   Dockerfile       : [$DOCKER_FILE_NAME]"
	echo "   Base Image       : [$DOCKER_BASE_IMAGE]"
fi

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

# Check for existing ubuntu base os image:
if [[ "$(docker images -q $DOCKER_BASE_IMAGE 2> /dev/null)" == "" ]]; then
  	echo "Base docker image [missing] ("$DOCKER_BASE_IMAGE")"
 	exit $EX_OSFILE
else
	echo "Base docker image [found] ("$DOCKER_BASE_IMAGE")"
fi

# Check for dependency files in the build context
# Since these builds use WGET instead of COPY or ADD
# files links within the build context can point outside
# the context and they will get transferred just fine.

# Check for keyboard configuration file
if [ -f $KEYBOARD_CONFIG_FILE ] || [ -L $KEYBOARD_CONFIG_FILE ]; then
	echo "Keyboard Configuration: [Good] "$KEYBOARD_CONFIG_FILE
else
	echo "ERROR: Keyboard Configuration: [Missing] "$KEYBOARD_CONFIG_FILE
	exit $EX_OSFILE
fi

# Check for XTerm configuration file
if [ -f $XTERM_CONFIG_FILE ] || [ -L $XTERM_CONFIG_FILE ]; then
	echo "XTerm Configuration File: [Good] "$XTERM_CONFIG_FILE
else
	# File does not exist
	echo "ERROR: XTerm Configuration File: [Missing] "$XTERM_CONFIG_FILE
	exit $EX_OSFILE
fi

# Check for Minicom configuration file
if [ -f $MINICOM_CONFIG_FILE ] || [ -L $MINICOM_CONFIG_FILE ]; then
	echo "Minicom Configuration File: [Good] "$MINICOM_CONFIG_FILE
else
	# File does not exist
	echo "ERROR: Minicom Configuration File: [Missing] "$MINICOM_CONFIG_FILE
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
echo "DOCKER_BASE_IMAGE="$DOCKER_BASE_IMAGE
echo "DOCKER_FILE_STAGE="$DOCKER_FILE_STAGE
echo "DOCKER_IMAGE="$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_VERSION
echo "DOCKER_INSTALL_DIR="$DOCKER_INSTALL_DIR
echo "INSTALL_SERVER_URL="$INSTALL_SERVER_URL
echo "-----------------------------------"
echo "Arguments..."
echo "-----------------------------------"
echo "	--build-arg VAI_USER=\"${VAI_USER}\""
echo "  --build-arg VAI_ROOT=\"${VAI_ROOT}\""
echo "  --build-arg VAI_GROUP=\"${VAI_GROUP}\""
echo "  --build-arg VAI_HOME=\"${VAI_HOME}\""
echo " 	--build-arg GIT_USER_NAME=\"${GIT_USER_NAME}\""
echo " 	--build-arg GIT_USER_EMAIL=\"${GIT_USER_EMAIL}\""
echo " 	--build-arg KEYBOARD_CONFIG_FILE=\"${KEYBOARD_CONFIG_FILE}\""
echo " 	--build-arg INSTALL_SERVER_URL=\"${SERVER_IP}:8000\""
echo "  --build-arg BUILD_DEBUG=\"${FLAG_BUILD_DEBUG}\""
echo "  --build-arg XTERM_CONFIG_FILE=\"${XTERM_CONFIG_FILE}\""
echo "  --build-arg MINICOM_CONFIG_FILE=\"${MINICOM_CONFIG_FILE}\""
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg VAI_USER="${VAI_USER}" \
 	--build-arg VAI_GROUP="${VAI_GROUP}" \
 	--build-arg VAI_ROOT="${VAI_ROOT}" \
 	--build-arg VAI_HOME="${VAI_HOME}" \
 	--build-arg GIT_USER_NAME="${GIT_USER_NAME}" \
 	--build-arg GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
 	--build-arg KEYBOARD_CONFIG_FILE="${KEYBOARD_CONFIG_FILE}" \
 	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
 	--build-arg BUILD_DEBUG="${FLAG_BUILD_DEBUG}" \
 	--build-arg XTERM_CONFIG_FILE="${XTERM_CONFIG_FILE}" \
   	--build-arg MINICOM_CONFIG_FILE="${MINICOM_CONFIG_FILE}" \
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
