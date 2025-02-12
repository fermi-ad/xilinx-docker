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
#	- 7/25/2019
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

# Check for Xilinx XSDK Offline Installer (Used to create a targeted offline installer)
if [ -f $XLNX_XSDK_OFFLINE_INSTALLER ] || [ -L $XLNX_XSDK_OFFLINE_INSTALLER ]; then
	echo "Xilinx XSDK Offline Installer: [Good] "$XLNX_XSDK_OFFLINE_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx XSDK Offline Installer: [Missing] "$XLNX_XSDK_OFFLINE_INSTALLER
	exit $EX_OSFILE
fi

# Check for Xilinx Batch Mode Configuratino File
if [ -f $XLNX_XSDK_BATCH_CONFIG_FILE ] || [ -L $XLNX_XSDK_BATCH_CONFIG_FILE ]; then
	echo "Xilinx Batch Mode Configuration File: [Good] "$XLNX_XSDK_BATCH_CONFIG_FILE
else
	# File does not exist
	echo "ERROR: Xilinx Batch Mode Configuration File: [Missing] "$XLNX_XSDK_BATCH_CONFIG_FILE
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
echo "  --build-arg XLNX_INSTALL_LOCATION=\"${XLNX_INSTALL_LOCATION}\""
echo " 	--build-arg INSTALL_SERVER_URL=\"${SERVER_IP}:8000\""
echo " 	--build-arg XLNX_XSDK_BATCH_CONFIG_FILE=\"${XLNX_XSDK_BATCH_CONFIG_FILE}\""
echo " 	--build-arg XLNX_XSDK_OFFLINE_INSTALLER=\"${XLNX_XSDK_OFFLINE_INSTALLER}\""
echo "  --build-arg BUILD_DEBUG=\"${BUILD_DEBUG}\""
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg USER_ACCT="${USER_ACCT}" \
 	--build-arg HOME_DIR="${HOME_DIR}" \
 	--build-arg XLNX_INSTALL_LOCATION="${XLNX_INSTALL_LOCATION}" \
  	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
  	--build-arg XLNX_XSDK_BATCH_CONFIG_FILE="${XLNX_XSDK_BATCH_CONFIG_FILE}" \
  	--build-arg XLNX_XSDK_OFFLINE_INSTALLER="${XLNX_XSDK_OFFLINE_INSTALLER}" \
 	--build-arg BUILD_DEBUG="${BUILD_DEBUG}" \
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
