#!/bin/bash
########################################################################################
# Fetch dependencies for image generation :
# - CUDA Container Repo Source
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 8/21/2023
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
	echo " --help"
	echo ""
	echo "      display this syntax help"
	echo ""
}

# Init command ling argument flags
FLAG_BUILD_DEBUG=0 # Enable extra debug messages

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
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

if [ $FLAG_BUILD_DEBUG -ne 0 ]; then 
	# Dump include variables used in this script
	echo "Repository      : [$REPO]"
	echo "Repository Path : [$REPO_PATH]"
	echo "Repository URL  : [$REPO_URL]"
fi

# Grab Start Time
FETCH_START_TIME=`date`

# Check for existing source
if [ ! -d ${REPO_LOCAL_PATH} ]; then

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

	# Clone the source repo
	git clone ${REPO_URL} ${REPO_LOCAL_PATH}

	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

	echo "# ${REPO} source checked out to"
	echo "#    ./${REPO_LOCAL_PATH}"
else
	echo "# WARNING: ${REPO} external source exists - SKIPPING fetch"
fi

# Grab End Time
FETCH_END_TIME=`date`
# Image Downloads Complete
echo "-----------------------------------"
echo "Task Complete..."
echo "STARTED :"$FETCH_START_TIME
echo "ENDED   :"$FETCH_END_TIME
echo "-----------------------------------"
