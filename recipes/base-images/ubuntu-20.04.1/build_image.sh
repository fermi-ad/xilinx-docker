#!/bin/bash
########################################################################################
# Docker Image Build Script:
#	- Create a base ubuntu image from a specific release ISO
#   - Create a base ubuntu image from a specific base tarball release
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/17/2020
########################################################################################
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
	echo "  --base"
	echo ""
	echo "      Generate docker image using the base release image"
	echo ""
	echo "  --iso"
	echo ""
	echo "      Generate docker image using the iso installer image"
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
FLAG_REPLACE_EXISTING=0 # Overwrite any existing files with new ones
FLAG_VERIFY_CHECKSUMS_ONLY=0 # Verify Checksums only

# Process Command line arguments
PARAMS=""

# Check that the script is run at root
if [ $(whoami) != root ]; then
	echo "This script must be executed as the root user."
	echo "Please execute this script using: sudo "$0
	exit $EX_OSFILE
fi

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
			shift
			;;
		--base) # Download the base release image
			FLAG_BASE_IMAGE=1
			echo "Set: FLAG_BASE_IMAGE_DOWNLOAD=$FLAG_BASE_IMAGE_DOWNLOAD"
			shift
			;;
		--iso) # Download the iso release image
			FLAG_ISO_IMAGE=1
			echo "Set: FLAG_ISO_IMAGE_DOWNLOAD=$FLAG_ISO_IMAGE_DOWNLOAD"
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

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi
	# Unmount ISO image
	echo "Unmounting ISO image..."
	umount -df $ROOTFS_TMPDIR

	# Remove working directories
	echo "Removing temporary directories..."
	rm -rf $SQUASHFS_TMPDIR $ROOTFS_TMPDIR

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

}

# Setup the base install image
if [ $FLAG_ISO_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting iso image parameters."; fi
	image_file[0]=$ISO_RELEASE_IMAGE
	image_checksum_type[0]=$ISO_RELEASE_CHECKSUM_TYPE
elif [ $FLAG_BASE_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting base image parameters."; fi
	image_file[0]=$BASE_RELEASE_IMAGE
	image_checksum_type[0]=$BASE_RELEASE_CHECKSUM_TYPE
else
	echo "No image specified."
	show_opts
	exit $EX_OSFILE
fi

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
	echo " Image Selected"
	echo " --------------------"
	echo "   Image[0]        : [${image_file[0]}]"
	echo "   ChecksumType[0] : [${image_checksum_type[0]}]"
fi

# Grab Start Time
XILINX_BUILD_START_TIME=`date`

# Check for and validate image integrity
if [ -f $DOWNLOAD_PATH/${image_file[0]} ] || [ -L $DOWNLOAD_PATH/${image_file[0]} ]; then
	if [[ -f $DOWNLOAD_PATH/${image_file[0]}.${image_checksum_type[0]} ]]; then
		echo "Image    [Found] :"${image_file[0]}
		echo "Checksum [Found] :"${image_file[0]}.${image_checksum_type[0]}
		# validate checksum
		pushd $DOWNLOAD_PATH > /dev/null 2>&1
		echo "Validating Checksum"
		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
			sha256sum -c --quiet ${image_file[0]}.${image_checksum_type[0]}
		else
			sha256sum -c ${image_file[0]}.${image_checksum_type[0]}
		fi
		popd
			
		if [[ $? -ne 0 ]]; then
			echo "********************************************"
			echo "** Checksum FAILED for [${image_file[0]}]"
			echo "********************************************"
			continue
		fi
	else
		echo "Checksum [Missing] :"${image_file[0]}.${image_checksum_type[0]}
		echo "Use the fetch_depends.sh script to download the required checksum files."
	fi
else
	echo "Image    [Missing] :"${image_file[0]}
	echo "Use the fetch_depends.sh script to download the required image files."
fi

# Generate the docker image
if [ $FLAG_ISO_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Generating docker image using iso installer."; fi

	# Automate extraction of a base rootfs from an ISO release
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi
	# Create a temporary working folder
	echo "Creating temporary directories..."
	mkdir -p $ROOTFS_TMPDIR $SQUASHFS_TMPDIR
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

	# Verify temporary working folders exist
	if [ ! -d $ROOTFS_TMPDIR ] || [ ! -d $SQUASHFS_TMPDIR ]; then
		echo "Error creating temporary directories"
		exit $EX_OSFILE
	fi

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi
	# Mount the ISO image temporarily
	echo "Mounting ISO image to temporary location"
	mount -o loop $DOWNLOAD_PATH/${image_file[0]} $ROOTFS_TMPDIR
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

	# Check for squashfs in mounted ISO
	if [ ! -f $ROOTFS_TMPDIR/$ISO_RELEASE_SQUASHFS_IMAGE ]; then
		echo "Error mounting ISO or squashfs image does not exist"
		ls -al $ROOTFS_TMPDIR/$ISO_RELEASE_SQUASHFS_IMAGE
		do_cleanup
		exit $EX_OSFILE
	fi

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi
	# Decompress squashfs
	echo "Decompressing Squashfs to temporary location"
	unsquashfs -f -d $SQUASHFS_TMPDIR $ROOTFS_TMPDIR/$ISO_RELEASE_SQUASHFS_IMAGE
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi
	echo "Importing rootfs into docker..."
	tar -C $SQUASHFS_TMPDIR -c . | docker import - $BASE_OS_NAME-iso:$BASE_OS_VERSION
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi
	# Show docker image
	docker image ls -a $BASE_OS_NAME-iso:$BASE_OS_VERSION
	do_cleanup
elif [ $FLAG_BASE_IMAGE -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Generating docker image using base installer."; fi
	# Import into a new image
	docker import $DOWNLOAD_PATH/${image_file[0]} $BASE_OS_NAME:$BASE_OS_VERSION
	# Show docker image
	docker image ls -a $BASE_OS_NAME:$BASE_OS_VERSION
fi

# Grab End Time
XILINX_BUILD_END_TIME=`date`
echo "-----------------------------------"
# Show docker images
docker image ls -a ${BASE_OS_NAME}*:$BASE_OS_VERSION
echo "-----------------------------------"
echo "Task Complete..."
echo "STARTED :"$XILINX_BUILD_START_TIME
echo "ENDED   :"$XILINX_BUILD_END_TIME
echo "-----------------------------------"