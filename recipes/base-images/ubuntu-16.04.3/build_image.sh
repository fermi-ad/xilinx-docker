#!/bin/bash
########################################################################################
# Docker Image Build Script:
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 9/4/2018
#
source include/configuration.sh

# Check for downloaded tarball
if [ -f depends/$UBUNTU_RELEASE_ARCHIVE ] || [ -L depends/$UBUNTU_RELEASE_ARCHIVE ]; then
	echo "Base Release Image [Good] "$UBUNTU_RELEASE_ARCHIVE
else
	echo "Base Release Image [Missing] "$UBUNTU_RELEASE_ARCHIVE
	mkdir -p depends
	echo "Attempting to download "$UBUNTU_BASE_URL"/"$UBUNTU_VERSION"/release/"$UBUNTU_RELEASE_ARCHIVE
	
	if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
	
	wget $UBUNTU_BASE_URL/$UBUNTU_VERSION/release/$UBUNTU_RELEASE_ARCHIVE -O depends/$UBUNTU_RELEASE_ARCHIVE
	
	if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

	if [ -f depends/$UBUNTU_RELEASE_ARCHIVE ]; then
		echo "Base Relese Image Download [Good] "$UBUNTU_RELEASE_ARCHIVE
	else
		echo "Base Release Image Download [failed] "$UBUNTU_RELEASE_ARCHIVE
		exit $EX_OSFILE
	fi
fi

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

# Import into a new image
docker import depends/$UBUNTU_RELEASE_ARCHIVE ubuntu:$UBUNTU_VERSION
# Show docker images
docker image ls -a
# Show docker disk use
docker system df

if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

