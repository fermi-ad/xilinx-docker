#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Uses: Dockerfile
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 7/24/2019
#
# Source configuration information for a v2018.3 Vivado Image build
source include/configuration.sh

# Set the Docker File for Vivado
DOCKER_FILE_NAME=Dockerfile

# Grab Start Time
DOCKER_BUILD_START_TIME=`date`

# Check that dependencies are not symbolic links, but actual files
# Docker won't be able to user files during build that are linked
# Because the actual file resides outside of the 'context' of the
# docker build.  This script will present an error when
# a symbolically linked dependency is encountered.

# Test for dependencies in order used
# 1. Base OS Image (i.e. Ubuntu:16.04.3)
# 2. Configurations (i.e. Keyboard, etc..)
# 3. Xilinx Tool Installers
# 4. Xilinx Tool Batch Mode Install Configuration Files

echo "-----------------------------------"
echo "Checking for dependencies..."
echo "-----------------------------------"

# Check for existing ubuntu base os image:
if [[ "$(docker images -q $DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG 2> /dev/null)" == "" ]]; then
  # create the docker base image
  	echo "Base docker image [missing] ("$DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG")"
 	exit $EX_OSFILE
else
	echo "Base docker image [found] ("$DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG")"
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

# Check for Xilinx XSDK Web Installer (Used to create a targeted offline installer)
if [ -f $XLNX_XSDK_WEB_INSTALLER ] || [ -L $XLNX_XSDK_WEB_INSTALLER ]; then
	echo "Xilinx XSDK WEB Installer: [Good] "$XLNX_XSDK_WEB_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx XSDK Web Installer: [Missing] "$XLNX_XSDK_WEB_INSTALLER
	exit $EX_OSFILE
fi
	
# Check for Xilinx XSDK Offline Installer (Used to create a targeted offline installer)
if [ -f $XLNX_XSDK_OFFLINE_INSTALLER ] || [ -L $XLNX_XSDK_OFFLINE_INSTALLER ]; then
	echo "Xilinx XSDK Offline Installer: [Good] "$XLNX_XSDK_OFFLINE_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx XSDK Offline Installer: [Missing] "$XLNX_XSDK_OFFLINE_INSTALLER
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

# Create docker folder
echo "-----------------------------------"
echo "Docker Build Context (Working)..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

cd $DOCKER_BUILD_WORKING_DIR

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "DOCKER_INSTALL_DIR="$DOCKER_INSTALL_DIR
echo "DOCKER_BUILD_WORKING_DIR="$DOCKER_BUILD_WORKING_DIR
echo "-----------------------------------"

# Launch a dummy python http server
# This allows the use of WGET instead of COPY to add external files to the docker image for installation purposes
# This reduces the overall size of the resulting image
echo "-----------------------------------"
echo "Launching Python HTTP Server..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

# Launch python3 http server ip address and capture process id
python3 -m http.server & SERVER_PID=$!
SERVER_IP=`ifconfig docker0 | grep 'inet\s' | awk '{print $2}'`

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

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
echo " 	--build-arg GIT_USER_NAME=\"${GIT_USER_NAME}\""
echo " 	--build-arg GIT_USER_EMAIL=\"${GIT_USER_EMAIL}\""
echo " 	--build-arg KEYBOARD_CONFIG_FILE=\"${KEYBOARD_CONFIG_FILE}\""
echo "  --build-arg XLNX_INSTALL_LOCATION=\"${XLNX_INSTALL_LOCATION}\""
echo " 	--build-arg INSTALL_SERVER_URL=\"${SERVER_IP}:8000\""
echo " 	--build-arg XLNX_XSDK_BATCH_CONFIG_FILE=\"${XLNX_XSDK_BATCH_CONFIG_FILE}\""
echo " 	--build-arg XLNX_XSDK_OFFLINE_INSTALLER=\"${XLNX_XSDK_OFFLINE_INSTALLER}\""
echo "  --build-arg BUILD_DEBUG=\"${BUILD_DEBUG}\""
echo "  --build-arg XTERM_CONFIG_FILE=\"${XTERM_CONFIG_FILE}\""
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg USER_ACCT="${USER_ACCT}" \
 	--build-arg HOME_DIR="${HOME_DIR}" \
 	--build-arg GIT_USER_NAME="${GIT_USER_NAME}" \
 	--build-arg GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
 	--build-arg KEYBOARD_CONFIG_FILE="${KEYBOARD_CONFIG_FILE}" \
 	--build-arg XLNX_INSTALL_LOCATION="${XLNX_INSTALL_LOCATION}" \
  	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
  	--build-arg XLNX_XSDK_BATCH_CONFIG_FILE="${XLNX_XSDK_BATCH_CONFIG_FILE}" \
  	--build-arg XLNX_XSDK_OFFLINE_INSTALLER="${XLNX_XSDK_OFFLINE_INSTALLER}" \
 	--build-arg BUILD_DEBUG="${BUILD_DEBUG}" \
 	--build-arg XTERM_CONFIG_FILE="${XTERM_CONFIG_FILE}" \
  	$DOCKER_INSTALL_DIR

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Shut down the python3 http server
echo "-----------------------------------"
echo "Shutting down Python HTTP Server..."
echo "-----------------------------------"
echo "Killing process ID "$SERVER_PID
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

kill $SERVER_PID

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Grab End Time
DOCKER_BUILD_END_TIME=`date`
# Docker Image Build Complete
echo "-----------------------------------"
echo "Image Build Complete..."
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
