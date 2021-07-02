#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Uses: Dockerfile
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 6/30/2021
#
# Unified Web Installer
#	./Xilinx_Unified_2021.1_0610_2318.bin--noexec --keep --nox11 --target unified_tmp
#	Creating directory unified_tmp
#
# Generate a batchmode configuration file
#	./xsetup -b ConfigGen -p <product>
# 		where	<product> can be: 
#			1. Vitis
#			2. Vivado
#			3. On-Premises Install for Cloud Deployments
#			4. BootGen
#			5. Lab Edition
#			6. Hardware Server
#			7. Documentation Navigator (Standalone)
#
# Source base image configuration
source ../../../base-images/ubuntu-20.04.1/include/configuration.sh
# Source user image configuration
source ../../../user-images/v2021.1/ubuntu-20.04.1-user/include/configuration.sh
# Source tool image configuration
source include/configuration.sh

# Additional setup and overrides specificaly for dependency generation
DOCKER_FILE_STAGE="base_os_depends_"$XLNX_RELEASE_VERSION
DOCKER_IMAGE_NAME=dependency_generation
DOCKER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

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
	echo "      Generate configurations using Dockerfile.base.generate_configs"
	echo ""
	echo "  --iso"
	echo ""
	echo "      Generate configurations using Dockerfile.iso.generate_configs"
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
		--base) # Use the base release image
			FLAG_BASE_IMAGE=1
			echo "Set: FLAG_BASE_IMAGE=$FLAG_BASE_IMAGE"
			shift
			;;
		--iso) # Use the iso release image
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
	DOCKER_FILE_NAME=Dockerfile.iso.generate_configs
	DOCKER_BASE_IMAGE=$BASE_OS_NAME-iso:$BASE_OS_VERSION
elif [ $FLAG_BASE_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting base image parameters."; fi
	DOCKER_FILE_NAME=Dockerfile.base.generate_configs
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
# Create docker folder
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

# Test for dependencies required to run this script
# 1. Unified Web Installer

# Check for dependency files in the build context
# Since these builds use WGET instead of COPY or ADD
# files links within the build context can point outside
# the context and they will get transferred just fine.

# Check for Xilinx Unified Web Installer
# This is required for building the offline installer package
if [ -f $XLNX_UNIFIED_WEB_INSTALLER ] || [ -L $XLNX_UNIFIED_WEB_INSTALLER ]; then
	echo "Xilinx Unified Web Installer: [Exists] "$XLNX_UNIFIED_WEB_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx Unified Web Installer: [Missing] "$XLNX_UNIFIED_WEB_INSTALLER
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
echo "  --build-arg XLNX_UNIFIED_WEB_INSTALLER=\"${XLNX_UNIFIED_WEB_INSTALLER}\""
echo "  --build-arg XLNX_UNIFIED_BATCH_CONFIG_FILE=\"${XLNX_UNIFIED_BATCH_CONFIG_FILE}\""
echo "  --build-arg XLNX_UNIFIED_OFFLINE_INSTALLER=\"${XLNX_UNIFIED_OFFLINE_INSTALLER}\""
echo "  --build-arg BUILD_DEBUG=\"${FLAG_BUILD_DEBUG}\""
echo "-----------------------------------"

# Build a base OS image to work in
if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker build $DOCKER_CACHE -f ./$DOCKER_FILE_NAME \
	--target $DOCKER_FILE_STAGE \
 	-t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
 	--build-arg USER_ACCT="${USER_ACCT}" \
 	--build-arg HOME_DIR="${HOME_DIR}" \
 	--build-arg XLNX_INSTALL_LOCATION="${XLNX_INSTALL_LOCATION}" \
 	--build-arg INSTALL_SERVER_URL="${INSTALL_SERVER_URL}" \
 	--build-arg KEYBOARD_CONFIG_FILE="${KEYBOARD_CONFIG_FILE}" \
 	--build-arg BUILD_DEBUG="${FLAG_BUILD_DEBUG}" \
 	$DOCKER_INSTALL_DIR

# Set Xhost permissions
xhost +

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Create a temporary container to work in

echo "-----------------------------------"
echo "Create a base docker container..."
echo "-----------------------------------"
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"
DOCKER_CONTAINER_NAME="build_"$XLNX_TOOL_INFO"_depends_"$XLNX_RELEASE_VERSION

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

# Create a docker container running in the background
docker run \
	--name $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=$DISPLAY \
	-itd $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION \
	/bin/bash

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo "Install support packages..."
echo "-----------------------------------"
# Install WGET and download the MALI user-space binaries

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
bash -c "if [ ${FLAG_BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& apt-get -y install wget"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Send commands to the docker container using 'docker exec'
# Ex: single command
#		$ docker exec -i <container_name> <command>
# Ex: multiple commands (with variable substitution inside the DOCKER container shell)
#		$ docker exec -i <container_name> bash -c '<command1> && <command2> && ...'
# Ex; multiple commands (with variable subsitution before passing to container shell)
#		$ docker exec -i <container_name> bash -c "<command1> && <command2> && ..."

echo "-----------------------------------"
echo "Building Offline Installer Configuration File..."
echo "-----------------------------------"
echo " - Install dependencies and download Unified installer into container..."
echo "-----------------------------------"
# Install the Xilinx dependencies and Vivado Installer

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${FLAG_BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& apt-get update \
	&& apt-get -y install file xorg \
	&& mkdir -p ${HOME_DIR}/downloads/tmp \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_UNIFIED_WEB_INSTALLER%/*} \
	&& wget -nv ${INSTALL_SERVER_URL}/${XLNX_UNIFIED_WEB_INSTALLER} -O ${XLNX_UNIFIED_WEB_INSTALLER} \
	&& chmod a+x ${XLNX_UNIFIED_WEB_INSTALLER} \
	&& ls -al ${XLNX_UNIFIED_WEB_INSTALLER}"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

echo "-----------------------------------"
echo " - Extract the Unified Installer and generate a batch mode config..."
echo "-----------------------------------"
# Extract the Unified Web Installer and run configGen

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker exec -it $DOCKER_CONTAINER_NAME \
	bash -c "if [ ${FLAG_BUILD_DEBUG} -ne 0 ]; then set -x; fi \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& ${XLNX_UNIFIED_WEB_INSTALLER} --noexec --nox11 --target unified_tmp \
	&& cd unified_tmp \
	&& ./xsetup -b ConfigGen -p ${XLNX_TOOL_INSTALLER_NAME} -l ${XLNX_INSTALL_LOCATION} \
	&& cd ${HOME_DIR}/downloads/tmp \
	&& mkdir -p ${XLNX_UNIFIED_BATCH_CONFIG_FILE%/*} \
	&& cp ~/.Xilinx/install_config.txt ${XLNX_UNIFIED_BATCH_CONFIG_FILE} \
	&& vi ${XLNX_UNIFIED_BATCH_CONFIG_FILE} \
	&& ls -al ${XLNX_UNIFIED_BATCH_CONFIG_FILE} \
	&& cat ${XLNX_UNIFIED_BATCH_CONFIG_FILE}"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# copy the batch mode configuration(s) to the host
echo "-----------------------------------"
echo "Copying Xilinx Unified batch mode configurations to host ..."
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

mkdir -p $GENERATED_PATH/${XLNX_UNIFIED_BATCH_CONFIG_FILE%/*}
docker cp $DOCKER_CONTAINER_NAME:$HOME_DIR/downloads/tmp/$XLNX_UNIFIED_BATCH_CONFIG_FILE $GENERATED_PATH/$XLNX_UNIFIED_BATCH_CONFIG_FILE
chmod +rw $GENERATED_PATH/$XLNX_UNIFIED_BATCH_CONFIG_FILE

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

# # Cleanup the container used to generate the dependencies
echo "-----------------------------------"
echo "Removing temporary docker resources..."
echo "-----------------------------------"

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

docker rm -f $DOCKER_CONTAINER_NAME
docker rmi -f $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

# Grab End Time
DOCKER_BUILD_END_TIME=`date`
# Docker Image Build Complete
echo "-----------------------------------"
echo "Configuration Generation Complete"
echo "-----------------------------------"
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
echo "DOCKER_FILE_NAME="$DOCKER_FILE_NAME
echo "DOCKER_FILE_STAGE="$DOCKER_FILE_STAGE
echo "DOCKER_IMAGE="$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_VERSION
echo "DOCKER_CONTAINER_NAME="$DOCKER_CONTAINER_NAME
echo "-----------------------------------"
echo "Configurations Generated:"
echo "-----------------------------------"
ls -al $GENERATED_PATH/$XLNX_UNIFIED_BATCH_CONFIG_FILE
echo "-----------------------------------"
echo "Copying Configurations to the $INSTALL_CONFIGS_DIR Folder"
echo "-----------------------------------"
cp -f $GENERATED_PATH/$XLNX_UNIFIED_BATCH_CONFIG_FILE $XLNX_UNIFIED_BATCH_CONFIG_FILE