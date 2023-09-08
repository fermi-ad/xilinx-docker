#!/bin/bash
########################################################################################
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 8/24/2023
#
# Image configuration for ```cuda-11.3.1-runtime-ubuntu20.04```
#
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
	echo "  --all"
	echo ""
	echo "		Enable all image targets"
	echo ""
	echo "  --base"
	echo ""
	echo "		Enable base image targets"
	echo ""
	echo "  --runtime"
	echo ""
	echo "		Enable runtime image targets"
	echo ""
	echo "  --devel"
	echo ""
	echo "		Enable devel image targets"
	echo ""
	echo "  --cudnn"
	echo ""
	echo "		Enable cudnn image targets (applies to runtime/devel only)"
	echo ""
	echo " --help"
	echo ""
	echo "      display this syntax help"
	echo ""
}

# Init command ling argument flags
FLAG_BUILD_DEBUG=0    # Enable extra debug messages
FLAG_BUILD_ALL=0      # Enable all image targets
FLAG_BUILD_BASE=0     # Enable base image targets
FLAG_BUILD_RUNTIME=0  # Enable runtime image targets
FLAG_BUILD_DEVEL=0    # Enable devel image targets
FLAG_BUILD_CUDNN=0    # Enable cudnn image targets

# Process Command line arguments
PARAMS=""

while (("$#")); do
	case "$1" in
		--debug) # Enable debug output
			FLAG_BUILD_DEBUG=1
			echo "Set: FLAG_BUILD_DEBUG=$FLAG_BUILD_DEBUG"
			shift
			;;
		--all) # Enable all image targets
			FLAG_BUILD_ALL=1
			echo "Set: FLAG_BUILD_ALL=$FLAG_BUILD_ALL"
			shift
			;;
		--base) # Enable base image targets
			FLAG_BUILD_BASE=1
			echo "Set: FLAG_BUILD_BASE=$FLAG_BUILD_BASE"
			shift
			;;
		--runtime) # Enable runtime image targets
			FLAG_BUILD_RUNTIME=1
			echo "Set: FLAG_BUILD_RUNTIME=$FLAG_BUILD_RUNTIME"
			shift
			;;
		--devel) # Enable devel image targets
			FLAG_BUILD_DEVEL=1
			echo "Set: FLAG_BUILD_DEVEL=$FLAG_BUILD_DEVEL"
			shift
			;;
		--cudnn) # Enable cudnn image targets
			FLAG_BUILD_CUDNN=1
			echo "Set: FLAG_BUILD_CUDNN=$FLAG_BUILD_CUDNN"
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
DOCKER_BUILD_START_TIME=`date`

# # Check that dependencies are not symbolic links, but actual files
# # Docker won't be able to user files during build that are linked
# # Because the actual file resides outside of the 'context' of the
# # docker build.  This script will present an error when
# # a symbolically linked dependency is encountered.

# Test for dependencies in order used
# 1. CUDA Repository Source
# 1. Base OS Image (i.e. Ubuntu:18.04.1)
# 2. Configurations (i.e. Keyboard, etc..)
# 3. Xilinx Tool Installers
# 4. Xilinx Tool Batch Mode Install Configuration Files

echo "-----------------------------------"
echo "Checking for dependencies..."
echo "-----------------------------------"

if [ ! -d ${REPO_LOCAL_PATH} ]; then
  	echo "CUDA Source [missing] ("${REPO_LOCAL_PATH}")"
 	exit $EX_OSFILE
else
	if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

	# Change to the CUDA source directory
	pushd ${REPO_LOCAL_PATH}

	# Prep source files 
	# - Copy container license files
	cp NGC-DL-CONTAINER-LICENSE ${BASE_PATH}/${OS_PATH_NAME}/base/
	cp -R entrypoint.d nvidia_entrypoint.sh ${BASE_PATH}/${OS_PATH_NAME}/runtime/

	# Return to base folder
	popd
fi

#######################################################################################
# Step #1
# - Build the BASE CUDA docker container
#   ./depends/cuda/dist/11.3.1/ubuntu2004/base/Dockerfile
#
# - From build script:
# Execute Non-CUDAGL build steps
#	run_cmd docker buildx build \
#        --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
#   	 -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
#    	"${BASE_PATH}/${OS_PATH_NAME}/base"
########################################################################################
if [[ $FLAG_BUILD_ALL -ne 0 || $FLAG_BUILD_BASE -ne 0 ]]; then
	# Check for existing docker image and build if doesn't exist
	if [[ "$(docker images -q ${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		echo "Building base docker image [${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION}]."

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		# Change to the CUDA source directory
		pushd ${REPO_LOCAL_PATH}

		docker build ${DOCKER_CACHE} \
			--platform ${PLATFORM_ARG} \
			-t "${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION}" \
			"${BASE_DOCKER_FILE_PATH}"

		# Return to base folder
		popd

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

		# Check for resulting docker image:
		if [[ "$(docker images -q ${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		  	echo "Base docker image [missing] ("${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION}")"
		 	exit $EX_OSFILE
		else
			echo "Base docker image [found] ("${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION}")"
		fi
	else
		echo "Skipping build..."
		echo "Base docker image [found] ("${BASE_DOCKER_IMAGE_NAME}:${BASE_DOCKER_IMAGE_VERSION}")"
	fi

	# Docker Image Build Complete
	echo "-----------------------------------"
	# Show docker images
	docker image ls -a $BASE_DOCKER_IMAGE_NAME:$BASE_DOCKER_IMAGE_VERSION
	echo "-----------------------------------"
fi

########################################################################################
# Step #2a
# - Build the RUNTIME CUDA docker image
#   ./depends/cuda/dist/11.3.1/ubuntu2004/runtime/Dockerfile
#
# - From build script:
# Execute Non-CUDAGL build steps
#   run_cmd docker buildx build --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
#       -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
#       --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
#       "${BASE_PATH}/${OS_PATH_NAME}/runtime"
########################################################################################
if [[ $FLAG_BUILD_ALL -ne 0 || $FLAG_BUILD_RUNTIME -ne 0 ]]; then
	# Check for existing docker image and build if doesn't exist
	if [[ "$(docker images -q ${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		echo "Building runtime docker image [${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION}]."

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		# Change to the CUDA source directory
		pushd ${REPO_LOCAL_PATH}

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		docker build ${DOCKER_CACHE} \
			--platform ${PLATFORM_ARG} \
			-t "${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION}" \
			--build-arg "IMAGE_NAME=${IMAGE_NAME}" \
			"${RUNTIME_DOCKER_FILE_PATH}"

		# Return to base folder
		popd

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

		# Check for resulting docker image:
		if [[ "$(docker images -q ${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		  	echo "Runtime docker image [missing] ("${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION}")"
		 	exit $EX_OSFILE
		else
			echo "Runtime docker image [found] ("${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION}")"
		fi
	else
		echo "Skipping build..."
		echo "Runtime docker image [found] ("${RUNTIME_DOCKER_IMAGE_NAME}:${RUNTIME_DOCKER_IMAGE_VERSION}")"
	fi

	# Docker Image Build Complete
	echo "-----------------------------------"
	# Show docker images
	docker image ls -a $RUNTIME_DOCKER_IMAGE_NAME:$RUNTIME_DOCKER_IMAGE_VERSION
	echo "-----------------------------------"
fi

########################################################################################
# Step #2b
# - Build the CUDNN RUNTIME CUDA docker image
#   ./depends/cuda/dist/11.3.1/ubuntu2004/runtime/cudnn8/Dockerfile
#
# - Not in build script:
# Execute Non-CUDAGL build steps
#   run_cmd docker buildx build --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
#       -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
#       --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
#       "${BASE_PATH}/${OS_PATH_NAME}/runtime/cudnn8"
########################################################################################
if [[ $FLAG_BUILD_ALL -ne 0 || $FLAG_BUILD_CUDNN -ne 0 && $FLAG_BUILD_RUNTIME -ne 0 ]]; then
	# Check for existing docker image and build if doesn't exist
	if [[ "$(docker images -q ${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		echo "Building runtime cudnn docker image [${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION}]."

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		# Change to the CUDA source directory
		pushd ${REPO_LOCAL_PATH}

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		docker build ${DOCKER_CACHE} \
			--platform ${PLATFORM_ARG} \
			-t "${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION}" \
			--build-arg "IMAGE_NAME=${IMAGE_NAME}" \
			"${CUDNN_RUNTIME_DOCKER_FILE_PATH}"

		# Return to base folder
		popd

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

		# Check for resulting docker image:
		if [[ "$(docker images -q ${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		  	echo "Runtime cudnn docker image [missing] ("${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION}")"
		 	exit $EX_OSFILE
		else
			echo "Runtime cudnn docker image [found] ("${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION}")"
		fi
	else
		echo "Skipping build..."
		echo "Runtime docker image [found] ("${CUDNN_RUNTIME_DOCKER_IMAGE_NAME}:${CUDNN_RUNTIME_DOCKER_IMAGE_VERSION}")"
	fi

	# Docker Image Build Complete
	echo "-----------------------------------"
	# Show docker images
	docker image ls -a $CUDNN_RUNTIME_DOCKER_IMAGE_NAME:$CUDNN_RUNTIME_DOCKER_IMAGE_VERSION
	echo "-----------------------------------"
fi

########################################################################################
# Step #3a
# - Build the DEVEL CUDA docker image
#   ./depends/cuda/dist/11.3.1/ubuntu2004/devel/Dockerfile
#
# - From build script:
# Execute Non-CUDAGL build steps
#   run_cmd docker buildx build --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
#      -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
#      --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
#      "${BASE_PATH}/${OS_PATH_NAME}/devel"
########################################################################################
if [[ $FLAG_BUILD_ALL -ne 0 || $FLAG_BUILD_DEVEL -ne 0 ]]; then
	# Check for existing docker image and build if doesn't exist
	if [[ "$(docker images -q ${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		echo "Building devel docker image [${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION}]."

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		# Change to the CUDA source directory
		pushd ${REPO_LOCAL_PATH}

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		docker build ${DOCKER_CACHE} \
			--platform ${PLATFORM_ARG} \
			-t "${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION}" \
			--build-arg "IMAGE_NAME=${IMAGE_NAME}" \
			"${DEVEL_DOCKER_FILE_PATH}"

		# Return to base folder
		popd

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

		# Check for resulting docker image:
		if [[ "$(docker images -q ${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		  	echo "Devel docker image [missing] ("${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION}")"
		 	exit $EX_OSFILE
		else
			echo "Devel docker image [found] ("${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION}")"
		fi
	else
		echo "Skipping build..."
		echo "Devel docker image [found] ("${DEVEL_DOCKER_IMAGE_NAME}:${DEVEL_DOCKER_IMAGE_VERSION}")"
	fi

	# Docker Image Build Complete
	echo "-----------------------------------"
	# Show docker images
	docker image ls -a $DEVEL_DOCKER_IMAGE_NAME:$DEVEL_DOCKER_IMAGE_VERSION
	echo "-----------------------------------"
fi

########################################################################################
# Step #3b
# - Build the DEVEL CUDA docker image
#   ./depends/cuda/dist/11.3.1/ubuntu2004/devel/cudnn8/Dockerfile
#
# - Not in build script:
# Execute Non-CUDAGL build steps
#   run_cmd docker buildx build --pull ${LOAD_ARG} ${PUSH_ARG} ${PLATFORM_ARG} \
#      -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}${OS_VERSION}${IMAGE_SUFFIX:+-${IMAGE_SUFFIX}}" \
#      --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
#      "${BASE_PATH}/${OS_PATH_NAME}/devel"
########################################################################################
if [[ $FLAG_BUILD_ALL -ne 0 || $FLAG_BUILD_CUDNN -ne 0 && $FLAG_BUILD_DEVEL -ne 0 ]]; then
	# Check for existing docker image and build if doesn't exist
	if [[ "$(docker images -q ${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		echo "Building devel docker image [${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION}]."

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		# Change to the CUDA source directory
		pushd ${REPO_LOCAL_PATH}

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set -x; fi

		docker build ${DOCKER_CACHE} \
			--platform ${PLATFORM_ARG} \
			-t "${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION}" \
			--build-arg "IMAGE_NAME=${IMAGE_NAME}" \
			"${CUDNN_DEVEL_DOCKER_FILE_PATH}"

		# Return to base folder
		popd

		if [ $FLAG_BUILD_DEBUG -ne 0 ]; then set +x; fi

		# Check for resulting docker image:
		if [[ "$(docker images -q ${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
		  	echo "Devel docker image [missing] ("${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION}")"
		 	exit $EX_OSFILE
		else
			echo "Devel docker image [found] ("${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION}")"
		fi
	else
		echo "Skipping build..."
		echo "Devel docker image [found] ("${CUDNN_DEVEL_DOCKER_IMAGE_NAME}:${CUDNN_DEVEL_DOCKER_IMAGE_VERSION}")"
	fi

	# Docker Image Build Complete
	echo "-----------------------------------"
	# Show docker images
	docker image ls -a $CUDNN_DEVEL_DOCKER_IMAGE_NAME:$CUDNN_DEVEL_DOCKER_IMAGE_VERSION
	echo "-----------------------------------"
fi

# Grab End Time
DOCKER_BUILD_END_TIME=`date`

# Docker Image Build Complete
echo "-----------------------------------"
# Show docker images
docker image ls -a $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
echo "-----------------------------------"
echo "Image Build Complete..."
echo "STARTED :"$DOCKER_BUILD_START_TIME
echo "ENDED   :"$DOCKER_BUILD_END_TIME
echo "-----------------------------------"
