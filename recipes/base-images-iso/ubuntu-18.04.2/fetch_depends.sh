#!/bin/bash
########################################################################################
# Fetch dependencies for image generation :
# - Ubuntu ISO Installer(s)
# - Ubuntu Base Root Filesystem(s)
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
	echo "  --remove-existing"
	echo ""
	echo "      Remove existing files."
	echo ""
	echo "  --verify-checksums-only"
	echo ""
	echo "      Only verify checksums for existing files, skip download process"
	echo ""
	echo " --help"
	echo ""
	echo "      display this syntax help"
	echo ""
}

# Init command ling argument flags
BUILD_DEBUG=0 # Enable extra debug messages
FLAG_REMOVE_EXISTING=0 # Remove any existing files before attempting a download
FLAG_VERIFY_CHECKSUMS_ONLY=0 # Verify Checksums only

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			BUILD_DEBUG=1
			echo "Set: BUILD_DEBUG=$BUILD_DEBUG"
			shift
			;;
		--remove-existing) # remove all existing files
			FLAG_REMOVE_EXISTING=1
			if [ $BUILD_DEBUG -ne 0 ]; then echo "Set: FLAG_REMOVE_EXISTING=$FLAG_REMOVE_EXISTING"; fi
			shift
			;;
		--verify-checksums-only) # verify checksums
			FLAG_VERIFY_CHECKSUMS_ONLY=1
			if [ $BUILD_DEBUG -ne 0 ]; then echo "Set: FLAG_VERIFY_CHECKSUMS_ONLY=$FLAG_VERIFY_CHECKSUMS_ONLY"; fi
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

# Grab Start Time
FETCH_START_TIME=`date`

# Flow overview:
# --------------
# 1. Does download exist?
#    Y -> verify checksum?
#         Y -> done for this image
#         N -> download image
#    N -> download image
# 2. Download image
# 3. Verify checksum?
#    Y -> done
#    N -> ABORT
# --------------

#if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi

# Check for existing downloads

if [[ FLAG_VERIFY_CHECKSUMS_ONLY -eq 0 ]]; then
			
	if [[ FLAG_REMOVE_EXISTING -ne 0 ]]; then
		if [ $BUILD_DEBUG -ne 0 ]; then echo "- Removing existing files."; fi
			rm -f depends/$UBUNTU_RELEASE_ARCHIVE
			rm -f depends/$UBUNTU_RELEASE_CHECKSUM_FILE
	fi

	# Does the download already exist?
	if [[ -f depends/$UBUNTU_RELEASE_ARCHIVE ]] || [[ -L $depends/$UBUNTU_RELEASE_ARCHIVE ]]; then
		if [ $BUILD_DEBUG -ne 0 ]; then echo "- Skipping Download (file exists)."; fi
	else
		echo "- Downloading [depends/$UBUNTU_RELEASE_ARCHIVE]"
		if [ $BUILD_DEBUG -ne 0 ]; then 
			wget -nv -x --show-progress \
				$UBUNTU_BASE_URL/$UBUNTU_RELEASE_ARCHIVE \
				-O depends/$UBUNTU_RELEASE_ARCHIVE
		else
			wget -q -x \
				$UBUNTU_BASE_URL/$UBUNTU_RELEASE_ARCHIVE \
				-O depends/$UBUNTU_RELEASE_ARCHIVE
		fi
	fi

	# Does the download have a checksum file?
	if [[ -f depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE ]]; then
		if [ $BUILD_DEBUG -ne 0 ]; then echo "- Skipping Download (checksum file exists)."; fi
	else
		echo "- Downloading [depends/$UBUNTU_RELEASE_CHECKSUM_FILE]"
		if [ $BUILD_DEBUG -ne 0 ]; then 
			wget -nv -x --show-progress \
				$UBUNTU_BASE_URL/$UBUNTU_RELEASE_CHECKSUM_FILE \
				-O depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
		else
			wget -q -x \
				$UBUNTU_BASE_URL/$UBUNTU_RELEASE_CHECKSUM_FILE \
				-O depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
		fi
		
		# Separate out checksum information for this particular image and overwrite download
		cat depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE \
			| grep $UBUNTU_RELEASE_ARCHIVE \
			> depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE.tmp \
			&& \
			mv depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE.tmp \
			depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
		
		if [ $BUILD_DEBUG -ne 0 ]; then 
			echo "- Downloaded Checksum"
			cat depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
			echo "---------------------------"
		fi
	fi

fi

# Validate checksum
if [[ -f depends/$UBUNTU_RELEASE_ARCHIVE ]] || [[ -L $depends/$UBUNTU_RELEASE_ARCHIVE ]]; then
	if [[ -f depends/$UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE ]]; then
		# validate checksum
		pushd depends > /dev/null 2>&1
		echo "- Validate Checksum"
		if [ $BUILD_DEBUG -ne 0 ]; then 
			sha256sum -c --quiet $UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
		else
			sha256sum -c $UBUNTU_RELEASE_ARCHIVE.$UBUNTU_RELEASE_CHECKSUM_TYPE
		fi

		if [[ $? -ne 0 ]]; then
			echo "********************************************"
			echo "** Checksum FAILED for [$UBUNTU_RELEASE_ARCHIVE]"
			echo "** Aborting Script"
			echo "********************************************"
			popd
			exit $EX_OSFILE
		fi
	else
		# checksum missing
		echo "********************************************"
		echo "** Checksum MISSING for [$UBUNTU_RELEASE_ARCHIVE]"
		echo "** Aborting Script"
		echo "********************************************"
		popd
		exit $EX_OSFILE
	fi
else
	# download missing
	# checksum missing
	echo "********************************************"
	echo "** File MISSING for [$UBUNTU_RELEASE_ARCHIVE]"
	echo "** Aborting Script"
	echo "********************************************"
	popd
	exit $EX_OSFILE
fi


# List images and checksum files
if [ $BUILD_DEBUG -ne 0 ]; then 
	# Dump include variables used in this script
	echo "----------------------------------------------"
	ls -al ${UBUNTU_RELEASE_ARCHIVE}*
fi

# Grab End Time
FETCH_END_TIME=`date`
# Image Downloads Complete
echo "-----------------------------------"
echo "Task Complete..."
echo "STARTED :"$FETCH_START_TIME
echo "ENDED   :"$FETCH_END_TIME
echo "-----------------------------------"

