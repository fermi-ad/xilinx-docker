# CONVERTED ORIGINAL BASH SCRIPT TO WINDOWS POWERSHELL SYNTAX
#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Create a base ubuntu image from a specific release tarball
#   - Base image tarballs for older releases can be found in the cdimage archive:
#		Link: http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 6/22/2019
#
. ".\include\configuration.ps1"

# Check for downloaded tarball
if (Test-Path "depends/$UBUNTU_RELEASE_ARCHIVE") {
		echo "Base Release Image [Good] $UBUNTU_RELEASE_ARCHIVE"
} else {
	echo "Base Release Image [Missing] $UBUNTU_RELEASE_ARCHIVE"	
	mkdir -Force depends
	echo "Attempting to download $UBUNTU_BASE_URL/$UBUNTU_VERSION/release/$UBUNTU_RELEASE_ARCHIVE"

	if ($BUILD_DEBUG -ne 0) {
	  # Turn on debug tracing (this script)
	  Set-PSDebug -Trace 1
	}

	wget "$UBUNTU_BASE_URL/$UBUNTU_VERSION/release/$UBUNTU_RELEASE_ARCHIVE" -Outfile "depends/$UBUNTU_RELEASE_ARCHIVE"

	if ($BUILD_DEBUG -ne 0) {
	  # Turn on debug tracing (this script)
	  Set-PSDebug -Trace 0
	}

	if (Test-Path "depends/$UBUNTU_RELEASE_ARCHIVE") {
		echo "Base Relese Image Download [Good] "$UBUNTU_RELEASE_ARCHIVE
	} else {
		echo "Base Release Image Download [failed] "$UBUNTU_RELEASE_ARCHIVE
		exit $EX_OSFILE
	}
}

if ($BUILD_DEBUG -ne 0) {
  # Turn on debug tracing (this script)
  Set-PSDebug -Trace 1
}

# Import into a new image
docker import "depends/$UBUNTU_RELEASE_ARCHIVE" "ubuntu:$UBUNTU_VERSION"
# Show docker images
docker image ls -a
# Show System disk use
docker system df

if ($BUILD_DEBUG -ne 0) {
  # Turn on debug tracing (this script)
  Set-PSDebug -Trace 0
}

