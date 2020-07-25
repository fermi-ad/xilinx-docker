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
#	- 7/25/2020
#
# SDK Web Installer
#	./Xilinx_SDK_2018.3_1207_2324_Lin64.bin --noexec --keep --nox11 --target vivado_tmp
#	Creating directory vivado_tmp
#
# Source configuration information for a v2019.1 SDK Image Build
source include/configuration.sh

# Additional setup and overrides specificaly for dependency generation
GENERATED_DIR=_generated
DOCKER_CONTAINER_NAME="build_"$XLNX_TOOL_INFO"_installer_"$XLNX_RELEASE_VERSION

# Grab Start Time
DOCKER_BUILD_START_TIME=`date`

# Check that dependencies are not symbolic links, but actual files
# Docker won't be able to user files during build that are linked
# Because the actual file resides outside of the 'context' of the
# docker build.  This script will present an error when
# a symbolically linked dependency is encountered.
# Create docker folder
echo "-----------------------------------"
echo "Checking for dependencies..."
echo "-----------------------------------"

# Check for existing ubuntu base os image:
if [[ "$(docker images -q $DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION 2> /dev/null)" == "" ]]; then
  # create the docker base image
  	echo "Base user image [missing] ("$DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION")"
  	echo "See the ./user-images/"$XLNX_RELEASE_VERSION" folder to create the required Docker image"
  	exit $EX_OSFILE
else
	echo "Base user image [found] ("$DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION")"
fi

# Test for dependencies required to run this script
# 1. SDK Web Installer

# Check for dependency files in the build context
# Since these builds use WGET instead of COPY or ADD
# files links within the build context can point outside
# the context and they will get transferred just fine.

# Check for Xilinx SDK Web Installer
# This is required for building the offline installer package
if [ -f $XLNX_XSDK_WEB_INSTALLER ] || [ -L $XLNX_XSDK_WEB_INSTALLER ]; then
	echo "Xilinx SDK Web Installer: [Exists] "$XLNX_XSDK_WEB_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx SDK Web Installer: [Missing] "$XLNX_XSDK_WEB_INSTALLER
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

cd $DOCKER_BUILD_WORKING_DIR

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

# Set Xhost permissions
xhost +

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Create a temporary container to work in
echo "-----------------------------------"
echo "Create a base docker container..."
echo "-----------------------------------"
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

# Create a docker container running in the background
docker run \
	--name $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=$DISPLAY \
	-itd $DOCKER_USER_IMAGE_NAME:$DOCKER_USER_IMAGE_VERSION \
	/bin/bash

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo "Install support packages..."
echo "-----------------------------------"
# Install WGET for transferring installers to container

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& sudo apt-get -y install wget"

# Send commands to the docker container using 'docker exec'
# Ex: single command
#		$ docker exec -i <container_name> <command>
# Ex: multiple commands (with variable substitution inside the DOCKER container shell)
#		$ docker exec -i <container_name> bash -c '<command1> && <command2> && ...'
# Ex; multiple commands (with variable subsitution before passing to container shell)
#		$ docker exec -i <container_name> bash -c "<command1> && <command2> && ..."

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo "Building Offline Installer Bundle..."
echo "-----------------------------------"
echo " - Install dependencies and download SDK Installer and configuration file into container..."
echo "-----------------------------------"
# Install the Xilinx dependencies and SDK Installer

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& sudo apt-get update \
	&& sudo apt-get -y install file xorg \
	&& mkdir -p ${HOME_DIR}/downloads/tmp \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_XSDK_WEB_INSTALLER%/*} \
	&& wget -nv ${INSTALL_SERVER_URL}/${XLNX_XSDK_WEB_INSTALLER} -O ${XLNX_XSDK_WEB_INSTALLER} \
	&& chmod a+x ${XLNX_XSDK_WEB_INSTALLER} \
	&& mkdir -p ${XLNX_XSDK_BATCH_CONFIG_FILE%/*} \
	&& wget -nv ${INSTALL_SERVER_URL}/${XLNX_XSDK_BATCH_CONFIG_FILE} -O ${XLNX_XSDK_BATCH_CONFIG_FILE} \
	&& ls -al ${XLNX_XSDK_WEB_INSTALLER}"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo " - Launch SDK Setup to create a download bundle..."
echo "-----------------------------------"
# Launch SDK Setup in X11 Mode to create download bundle
# Leave download location default (/opt/Xilinx/Downloads/<VERSION>)

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& ${XLNX_XSDK_WEB_INSTALLER} --noexec --nox11 --target unified_tmp \
	&& cd unified_tmp \
	&& sudo mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& sudo chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
	&& ./xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --config ${XLNX_XSDK_BATCH_CONFIG_FILE} \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_XSDK_OFFLINE_INSTALLER%/*} \
	&& tar -zcf ${XLNX_XSDK_OFFLINE_INSTALLER} -C /opt/Xilinx/Downloads/${XLNX_RELEASE_VERSION} . \
	&& ls -al /opt/Xilinx/Downloads/${XLNX_RELEASE_VERSION}"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# copy SDK offline installer from container to host
echo "-----------------------------------"
echo "Copying Xilinx SDK offline installer to host ..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

mkdir -p $GENERATED_DIR/${XLNX_XSDK_OFFLINE_INSTALLER%/*}
docker cp $DOCKER_CONTAINER_NAME:$HOME_DIR/downloads/tmp/$XLNX_XSDK_OFFLINE_INSTALLER $GENERATED_DIR/$XLNX_XSDK_OFFLINE_INSTALLER

# Shut down the python3 http server
echo "-----------------------------------"
echo "Shutting down Python HTTP Server..."
echo "-----------------------------------"
echo "Killing process ID "$SERVER_PID
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

kill $SERVER_PID

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# # Cleanup the container used to generate the dependencies
echo "-----------------------------------"
echo "Removing temporary docker resources..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker rm -f $DOCKER_CONTAINER_NAME
docker rmi -f $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Grab End Time
DOCKER_BUILD_END_TIME=`date`
# Docker Image Build Complete
echo "-----------------------------------"
echo "Configuration Generation Complete"
echo "-----------------------------------"
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
echo "DOCKER_FILE_STAGE="$DOCKER_FILE_STAGE
echo "DOCKER_IMAGE="$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_VERSION
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"
echo "Xilinx offline installer generated:"
echo "-----------------------------------"
ls -al $GENERATED_DIR/$XLNX_XSDK_OFFLINE_INSTALLER
echo "-----------------------------------"
echo "Linking installer to dependencies folder"
echo "-----------------------------------"
ln -s ../$GENERATED_DIR/$XLNX_XSDK_OFFLINE_INSTALLER $XLNX_XSDK_OFFLINE_INSTALLER
