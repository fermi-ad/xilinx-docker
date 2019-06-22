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
#	- 6/22/2019
#
# Vivado Web Installer
#	./Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin --noexec --keep --nox11 --target vivado_tmp
#	Creating directory vivado_tmp
#
# Generate a batchmode configuration file
#	./xsetup -b ConfigGen
#
# Source configuration information for a v2019.1 Vivado Image build
source include/configuration.sh

# Set the Docker File for Vivado
DOCKER_FILE_NAME=Dockerfile

# Additional setup and overrides specificaly for dependency generation
GENERATED_DIR=_generated
DOCKER_FILE_STAGE="base_os_"$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
DOCKER_IMAGE_NAME=dependency_generation
DOCKER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

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
if [[ "$(docker images -q $DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG 2> /dev/null)" == "" ]]; then
  # create the docker base image
  	echo "Base docker image [missing] ("$DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG")"
  	echo "See the ./base_os/"$DOCKER_BASE_OS"_"$DOCKER_BASE_OS_TAG" folder to create this image"
  	exit $EX_OSFILE
else
	echo "Base docker image [found] ("$DOCKER_BASE_OS:$DOCKER_BASE_OS_TAG")"
fi

# Check for Xilinx MALI binaries
if [ -f $XLNX_MALI_BINARY ] || [ -L $XLNX_MALI_BINARY ]; then
	echo "Xilinx MALI Binaries: [Good] "$XLNX_MALI_BINARY
else
	echo "ERROR: Xilinx MALI Binaries: [Missing] "$XLNX_MALI_BINARY
	echo "Download the Xilinx MALI Binaries here:"
	echo "https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html"
	exit $EX_OSFILE
fi

# Test for dependencies required to run this script
# 1. Vivado Web Installer

# Check for dependency files in the build context
# Since these builds use WGET instead of COPY or ADD
# files links within the build context can point outside
# the context and they will get transferred just fine.

# Check for Xilinx Vivado SDK Web Installer
# This is required for building the offline installer package
if [ -f $XLNX_VIVADO_WEB_INSTALLER ] || [ -L $XLNX_VIVADO_WEB_INSTALLER ]; then
	echo "Xilinx Vivado Web Installer: [Exists] "$XLNX_VIVADO_WEB_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx Vivado Web Installer: [Missing] "$XLNX_VIVADO_WEB_INSTALLER
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

#Build the docker image
echo "-----------------------------------"
echo "Building the Docker Image..."
echo "-----------------------------------"
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
echo " 	--build-arg INSTALL_SERVER_URL=\"${SERVER_IP}:8000\""
echo " 	--build-arg KEYBOARD_CONFIG_FILE=\"${KEYBOARD_CONFIG_FILE}\""
echo "  --build-arg XLNX_VIVADO_WEB_INSTALLER=\"${XLNX_VIVADO_WEB_INSTALLER}\""
echo "  --build-arg XLNX_VIVADO_BATCH_CONFIG_FILE=\"${XLNX_VIVADO_BATCH_CONFIG_FILE}\""
echo "  --build-arg XLNX_VIVADO_OFFLINE_INSTALLER=\"${XLNX_VIVADO_OFFLINE_INSTALLER}\""
echo "  --build-arg BUILD_DEBUG=\"${BUILD_DEBUG}\""
echo "-----------------------------------"

# Build a base OS image to work in
if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg USER_ACCT="${USER_ACCT}" \
 	--build-arg HOME_DIR="${HOME_DIR}" \
 	--build-arg XLNX_INSTALL_LOCATION="${XLNX_INSTALL_LOCATION}" \
 	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
 	--build-arg KEYBOARD_CONFIG_FILE="${KEYBOARD_CONFIG_FILE}" \
 	--build-arg BUILD_DEBUG="${BUILD_DEBUG}" \
 	$DOCKER_INSTALL_DIR

# Set Xhost permissions
xhost +

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Create a temporary container to work in

echo "-----------------------------------"
echo "Create a base docker container..."
echo "-----------------------------------"
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"
DOCKER_CONTAINER_NAME="build_"$XLNX_TOOL_INFO"_depends_"$XLNX_RELEASE_VERSION

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

# Create a docker container running in the background
docker run \
	--name $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=$DISPLAY \
	-itd $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
	/bin/bash

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo "Install support packages..."
echo "-----------------------------------"
# Install WGET and download the MALI user-space binaries

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& apt-get -y install wget"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Send commands to the docker container using 'docker exec'
# Ex: single command
#		$ docker exec -i <container_name> <command>
# Ex: multiple commands (with variable substitution inside the DOCKER container shell)
#		$ docker exec -i <container_name> bash -c '<command1> && <command2> && ...'
# Ex; multiple commands (with variable subsitution before passing to container shell)
#		$ docker exec -i <container_name> bash -c "<command1> && <command2> && ..."

echo "-----------------------------------"
echo "Generating Xilinx Keyboard Configuration... (Interactive)"
echo "-----------------------------------"
# Install the keyboard configuration
if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& apt-get install -y keyboard-configuration \
	&& sudo dpkg-reconfigure keyboard-configuration \
	&& mkdir -p ${HOME_DIR}/downloads/tmp \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${KEYBOARD_CONFIG_FILE%/*} \
	&& debconf-get-selections | grep keyboard-configuration > ${KEYBOARD_CONFIG_FILE} \
	&& ls -al"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# copy keyboard configuration from container to host
echo "-----------------------------------"
echo "Copying keyboard configuration to host..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

mkdir -p $GENERATED_DIR/${KEYBOARD_CONFIG_FILE%/*}
docker cp $DOCKER_CONTAINER_NAME:$HOME_DIR/downloads/tmp/$KEYBOARD_CONFIG_FILE $GENERATED_DIR/$KEYBOARD_CONFIG_FILE

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo "Building Offline Vivado Installer Bundle..."
echo "-----------------------------------"
echo " - Install dependencies and download Vivado installer into container..."
echo "-----------------------------------"
# Install the Xilinx dependencies and Vivado Installer

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& apt-get update \
	&& apt-get -y install file xorg \
	&& mkdir -p ${HOME_DIR}/downloads/tmp \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_VIVADO_WEB_INSTALLER%/*} \
	&& wget -nv ${INSTALL_SERVER_URL}/${XLNX_VIVADO_WEB_INSTALLER} -O ${XLNX_VIVADO_WEB_INSTALLER} \
	&& chmod a+x ${XLNX_VIVADO_WEB_INSTALLER} \
	&& ls -al ${XLNX_VIVADO_WEB_INSTALLER}"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo " - Extract the SDK Installer and generate a batch mode config..."
echo "-----------------------------------"
# Extract the SDK Web Installer and run configGen

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& ${XLNX_VIVADO_WEB_INSTALLER} --noexec --nox11 --target xsdk_tmp \
	&& cd xsdk_tmp \
	&& ./xsetup -b ConfigGen -l ${XLNX_INSTALL_LOCATION} \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_VIVADO_BATCH_CONFIG_FILE%/*} \
	&& cp ~/.Xilinx/install_config.txt ${XLNX_VIVADO_BATCH_CONFIG_FILE} \
	&& vi ${XLNX_VIVADO_BATCH_CONFIG_FILE} \
	&& ls -al ${XLNX_VIVADO_BATCH_CONFIG_FILE} \
	&& cat ${XLNX_VIVADO_BATCH_CONFIG_FILE}"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# copy the batch mode configuration(s) to the host
echo "-----------------------------------"
echo "Copying Xilinx Vivado batch mode configurations to host ..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

mkdir -p $GENERATED_DIR/${XLNX_VIVADO_BATCH_CONFIG_FILE%/*}
docker cp $DOCKER_CONTAINER_NAME:$HOME_DIR/downloads/tmp/$XLNX_VIVADO_BATCH_CONFIG_FILE $GENERATED_DIR/$XLNX_VIVADO_BATCH_CONFIG_FILE

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo " - Launch Vivado Setup to create a download bundle..."
echo "-----------------------------------"
# Launch Vivado Setup in X11 Mode to create download bundle
# Leave download location default (/opt/Xilinx/Downloads/<VERSION>)

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& cd ${HOME_DIR}/downloads/tmp/xsdk_tmp \
	&& ./xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --config ${XLNX_VIVADO_BATCH_CONFIG_FILE} \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_VIVADO_OFFLINE_INSTALLER%/*} \
	&& tar -zcf ${XLNX_VIVADO_OFFLINE_INSTALLER} -C /opt/Xilinx/Downloads/2018.3 . \
	&& ls -al /opt/Xilinx/Downloads/2018.3"

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# copy sdk offline installer from container to host
echo "-----------------------------------"
echo "Copying Xilinx Vivado offline installer to host ..."
echo "-----------------------------------"

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

mkdir -p $GENERATED_DIR/${XLNX_VIVADO_OFFLINE_INSTALLER%/*}
docker cp $DOCKER_CONTAINER_NAME:$HOME_DIR/downloads/tmp/$XLNX_VIVADO_OFFLINE_INSTALLER $GENERATED_DIR/$XLNX_VIVADO_OFFLINE_INSTALLER

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
echo "Dependency Generation Complete"
echo "-----------------------------------"
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
echo "DOCKER_FILE_NAME="$DOCKER_FILE_NAME
echo "DOCKER_FILE_STAGE="$DOCKER_FILE_STAGE
echo "DOCKER_IMAGE="$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_VERSION
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"
echo "Dependencies Generated:"
echo "-----------------------------------"
ls -al $GENERATED_DIR/$KEYBOARD_CONFIG_FILE
ls -al $GENERATED_DIR/$XLNX_VIVADO_BATCH_CONFIG_FILE
ls -al $GENERATED_DIR/$XLNX_VIVADO_OFFLINE_INSTALLER
echo "-----------------------------------"