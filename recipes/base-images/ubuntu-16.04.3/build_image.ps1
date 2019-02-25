# CONVERTED ORIGINAL BASH SCRIPT TO WINDOWS POWERSHELL SYNTAX
#!/bin/bash
########################################################################################
# Docker Image Build Script:

#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 10/24/2018
#
# Ubuntu Revision (Xenial Xaurus) v16.04.3
# Source configuration created for v2018.2 builds
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

