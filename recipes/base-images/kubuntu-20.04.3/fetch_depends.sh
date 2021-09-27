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
#	- 9/24/2021
########################################################################################
source include/configuration.sh

# Temporary variables repeatedly used in this script
ROOTFS_TMPDIR=$TMP_PATH/rootfs
SQUASHFS_TMPDIR=$TMP_PATH/unsquashfs

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
	echo "      Download the base release image"
	echo ""
	echo "  --iso"
	echo ""
	echo "      Download the iso release image"
	echo ""
	echo "  --replace-existing"
	echo ""
	echo "      Replace existing files."
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
FLAG_BUILD_DEBUG=0 # Enable extra debug messages
FLAG_BASE_IMAGE_DOWNLOAD=0 # Download the base release image
FLAG_ISO_IMAGE_DOWNLOAD=0 # Download the iso release image
FLAG_REPLACE_EXISTING=0 # Overwrite any existing files with new ones
FLAG_VERIFY_CHECKSUMS_ONLY=0 # Verify Checksums only

# Initialize the download count
#DOWNLOAD_COUNT=${#image_url[@]}
DOWNLOAD_COUNT=$((0))

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
			shift
			;;
		--base) # Download the base release image
			FLAG_BASE_IMAGE_DOWNLOAD=1
			echo "Set: FLAG_BASE_IMAGE_DOWNLOAD=$FLAG_BASE_IMAGE_DOWNLOAD"
			shift
			;;
		--iso) # Download the iso release image
			FLAG_ISO_IMAGE_DOWNLOAD=1
			echo "Set: FLAG_ISO_IMAGE_DOWNLOAD=$FLAG_ISO_IMAGE_DOWNLOAD"
			shift
			;;
		--replace-existing) # remove all existing files
			FLAG_REPLACE_EXISTING=1
			if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Set: FLAG_REPLACE_EXISTING=$FLAG_REPLACe_EXISTING"; fi
			shift
			;;
		--verify-checksums-only) # verify checksums
			FLAG_VERIFY_CHECKSUMS_ONLY=1
			if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Set: FLAG_VERIFY_CHECKSUMS_ONLY=$FLAG_VERIFY_CHECKSUMS_ONLY"; fi
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

# Setup the downloads
if [ $FLAG_BASE_IMAGE_DOWNLOAD -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting base image parameters for download."; fi
	image_url[$DOWNLOAD_COUNT]=$BASE_RELEASE_URL
	image_file[$DOWNLOAD_COUNT]=$BASE_RELEASE_IMAGE
	image_checksum_type[$DOWNLOAD_COUNT]=$BASE_RELEASE_CHECKSUM_TYPE
	image_checksum_file[$DOWNLOAD_COUNT]=$BASE_RELEASE_CHECKSUM_FILE
	DOWNLOAD_COUNT=$((DOWNLOAD_COUNT+1))
fi

if [ $FLAG_ISO_IMAGE_DOWNLOAD -eq 1 ]; then
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then echo "Setting iso image parameters for download."; fi
	image_url[$DOWNLOAD_COUNT]=$ISO_RELEASE_URL
	image_file[$DOWNLOAD_COUNT]=$ISO_RELEASE_IMAGE
	image_checksum_type[$DOWNLOAD_COUNT]=$ISO_RELEASE_CHECKSUM_TYPE
	image_checksum_file[$DOWNLOAD_COUNT]=$ISO_RELEASE_CHECKSUM_FILE
	DOWNLOAD_COUNT=$((DOWNLOAD_COUNT+1))
fi

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
	# Dump include variables used in this script
	echo "Downloads Path  : [$DOWNLOAD_PATH]"
	echo "Total Downloads : [$DOWNLOAD_COUNT]"

	for (( i=0; i < $DOWNLOAD_COUNT; i++ )); do
	echo " Download[$i]   : --------------------"
	echo "   URL[$i]          : [${image_url[$i]}]"
	echo "   Image[$i]        : [${image_file[$i]}]"
	echo "   ChecksumType[$i] : [${image_checksum_type[$i]}]"
	echo "   ChecksumFile[$i] : [${image_checksum_file[$i]}]"
	done
fi
#DOWNLOAD_COUNT=${#image_url[@]}

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

#if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

# Check for existing downloads

if [[ FLAG_VERIFY_CHECKSUMS_ONLY -eq 0 ]]; then
	for (( i=0; i < $DOWNLOAD_COUNT; i++ )); do
		# Does the download already exist?
		if [[ -f $DOWNLOAD_PATH/${image_file[$i]} ]] || [[ -L $DOWNLOAD_PATH/${image_file[$i]} ]]; then
			# Yes - should it be replaced?
			if [[ $FLAG_REPLACE_EXISTING -eq 0 ]]; then
				if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
					echo "- [$i]: Skipping Download (file exists).";
					continue
				fi
			fi
		fi 
		# Download the image
		echo "- [$i]: Downloading [${image_file[$i]}]"

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
			wget -nv -x --show-progress \
				${image_url[$i]}/${image_file[$i]} \
				-O $DOWNLOAD_PATH/${image_file}
		else
			wget -q -x \
				${image_url[$i]}/${image_file[$i]} \
				-O $DOWNLOAD_PATH/${image_file}
		fi
		
		# Does the download already have a checksum file?
		if [[ -f $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]} ]]; then
			# Yes - should it be replaced?
			if [[ $FLAG_REPLACE_EXISTING -eq 0 ]]; then
				if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
					echo "- [$i]: Skipping Download (checksum file exists).";
					continue
				fi
			fi
		fi

		echo "- [$i]: Downloading [${image_file[$i]}:${image_checksum_file[$i]}]"
		
		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
			wget -nv -x --show-progress \
				${image_url[$i]}/${image_checksum_file[$i]} \
				-O $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}
		else
			wget -q -x \
				${image_url[$i]}/${image_checksum_file[$i]} \
				-O $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}
		fi

		# Separate out checksum information for this particular image and overwrite download
		cat $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]} \
			| grep ${image_file[$i]} \
			> $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}.tmp

		mv $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}.tmp \
			$DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}
		
		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
			echo "- [$i]: Downloaded Checksum"
			cat $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]}
			echo "---------------------------"
		fi
		set +x
	done
fi


# Validate checksum
for (( i=0; i < $DOWNLOAD_COUNT; i++ )); do
	if [[ -f $DOWNLOAD_PATH/${image_file[$i]} ]] || [[ -L $$DOWNLOAD_PATH/${image_file[$i]} ]]; then
		if [[ -f $DOWNLOAD_PATH/${image_file[$i]}.${image_checksum_type[$i]} ]]; then
			# validate checksum
			pushd $DOWNLOAD_PATH > /dev/null 2>&1
			echo "- Validate Checksum"
			if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
				sha256sum -c --quiet ${image_file[$i]}.${image_checksum_type[$i]}
			else
				sha256sum -c ${image_file[$i]}.${image_checksum_type[$i]}
			fi

			popd
			
			if [[ $? -ne 0 ]]; then
				echo "********************************************"
				echo "** Checksum FAILED for [${image_file[$i]}]"
				echo "********************************************"
				continue
				#exit $EX_OSFILE
			fi
		else
			# checksum missing
			echo "********************************************"
			echo "** Checksum MISSING for [${image_file[$i]}]"
			echo "** Aborting Script"
			echo "********************************************"
			popd
			continue
			#exit $EX_OSFILE
		fi
	else
		# download missing
		# checksum missing
		echo "********************************************"
		echo "** File MISSING for [${image_file[$i]}]"
		echo "** Aborting Script"
		echo "********************************************"
		popd
		continue
		#exit $EX_OSFILE
	fi
done

# List images and checksum files
if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
	# Dump include variables used in this script
	echo "Base Path       : [$path_base]"
	echo "Include Path    : [$path_include]"
	echo "Downloads Path  : [$path_downloads]"
	echo "Total Downloads : [$DOWNLOAD_COUNT]"

	echo "----------------------------------------------"
	for (( i=0; i < $DOWNLOAD_COUNT; i++ )); do
		ls -al $DOWNLOAD_PATH/${image_file[$i]}*
	done
fi

# Grab End Time
FETCH_END_TIME=`date`
# Image Downloads Complete
echo "-----------------------------------"
echo "Task Complete..."
echo "STARTED :"$FETCH_START_TIME
echo "ENDED   :"$FETCH_END_TIME
echo "-----------------------------------"
