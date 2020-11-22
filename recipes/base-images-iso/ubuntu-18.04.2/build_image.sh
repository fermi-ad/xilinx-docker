#!/bin/bash
########################################################################################
# EXECUTE THIS SCRIPT AS SUPERUSER
########################################################################################
# Docker Image Build Script:
#	- Create a base ubuntu image from a specific release ISO
#   - ISOs for older releases can be found in the old release archive:
#		Link: http://old-releases.ubuntu.com/releases/
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/17/2020
#
source include/configuration.sh

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
BUILD_DEBUG=0 # Enable extra debug messages

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			BUILD_DEBUG=1
			echo "Set: BUILD_DEBUG=$BUILD_DEBUG"
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

# define options
function do_cleanup {

	if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
	# Unmount ISO image
	echo "Unmounting ISO image..."
	umount -df $ROOTFS_TMPDIR

	# Remove working directories
	echo "Removing temporary directories..."
	rm -rf $SQUASHFS_TMPDIR $ROOTFS_TMPDIR

	if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

}

# Check that the script is run at root
if [ $(whoami) != root ]; then
	echo "This script must be executed as the root user."
	echo "Please execute this script using: sudo "$0
	exit $EX_OSFILE
fi

# Grab Start Time
XILINX_BUILD_START_TIME=`date`

# Check for downloaded iso
if [ -f $DOWLOAD_PATH/$UBUNTU_RELEASE_ARCHIVE ] || [ -L depends/$UBUNTU_RELEASE_ARCHIVE ]; then
	echo "Base Release Image [Good] "$UBUNTU_RELEASE_ARCHIVE
else
	echo "Base Release Image [Missing] "$UBUNTU_RELEASE_ARCHIVE
	exit $EX_OSFILE
fi

# Automate extraction of a base rootfs from an ISO release
if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
# Create a temporary working folder
echo "Creating temporary directories..."
mkdir -p $ROOTFS_TMPDIR $SQUASHFS_TMPDIR


# Verify temporary working folders exist
if [ ! -d $ROOTFS_TMPDIR ] || [ ! -d $SQUASHFS_TMPDIR ]; then
	echo "Error creating temporary directories"
	exit $EX_OSFILE
fi

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
# Mount the ISO image temporarily
echo "Mounting ISO image to temporary location"
mount -o loop depends/$UBUNTU_RELEASE_ARCHIVE $ROOTFS_TMPDIR
if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi

# Check for squashfs in mounted ISO
if [ ! -f $ROOTFS_TMPDIR/$SQUASHFS_IMG ]; then
	echo "Error mounting ISO or squashfs image does not exist"
	ls -al $ROOTFS_TMPDIR/$SQUASHFS_IMG
	do_cleanup
	exit $EX_OSFILE
fi

if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
# Decompress squashfs
echo "Decompressing Squashfs to temporary location"
unsquashfs -f -d $SQUASHFS_TMPDIR $ROOTFS_TMPDIR/$SQUASHFS_IMG
if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi


if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi
echo "Importing rootfs into docker..."
tar -C $SQUASHFS_TMPDIR -c . | docker import - ubuntu-iso:$UBUNTU_VERSION
if [ $BUILD_DEBUG -ne 0 ]; then set +x; fi


do_cleanup

# Grab End Time
XILINX_BUILD_END_TIME=`date`
# Docker Image Build Complete
echo "-----------------------------------"
echo "Dependencies Downloaded/Generated"
ls -al depends
echo "-----------------------------------"
# Show docker images
docker image ls ubuntu-iso:$UBUNTU_VERSION
echo "-----------------------------------"
echo "Task Complete..."
echo "STARTED :"$XILINX_BUILD_START_TIME
echo "ENDED   :"$XILINX_BUILD_END_TIME
echo "-----------------------------------"
