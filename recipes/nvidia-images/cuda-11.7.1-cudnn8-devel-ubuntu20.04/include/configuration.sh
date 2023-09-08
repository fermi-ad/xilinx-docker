#!/bin/bash
########################################################################################
# Docker Image Build Variable Customization/Configuration:
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 8/24/2023
#
########################################################################################
# CUDA Docker Image Repository Information
########################################################################################
# Build Script Path definitions
DOWNLOAD_PATH=depends

# Source definitions
REPO=cuda
REPO_URL=https://gitlab.com/nvidia/container-images/cuda.git
REPO_LOCAL_PATH=${DOWNLOAD_PATH}/${REPO}

# Source configuration
CUDA_VERSION=11.7.1
OS=ubuntu
OS_VERSION=20.04
ARCHES=x86_64 # `arch` - See: https://github.com/docker-library/official-images#architectures-other-than-amd64


# Derived build script arguments
PLATFORM_ARG="linux/${ARCHES}"

# Docker configuration
IMAGE_NAME=nvidia/cuda

# Paths
BASE_PATH="dist/${CUDA_VERSION}"
#BASE_PATH="dist/end-of-life/${CUDA_VERSION}"
OS_PATH_NAME="${OS}${OS_VERSION//.}"
#OS_PATH_NAME="${OS}${OS_VERSION%.*}"

########################################################################################
# base image     : nvidia/cuda:11.7.1-base-ubuntu20.04
# runtime image  : nvidia/cuda:11.7.1-runtime-ubuntu20.04
# devel image    : nvidia/cuda:11.7.1-devel-ubuntu20.04
# cudnn8 image   : nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
# cudnn8 image   : nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
#######################################################################################
# base image     : nvidia/cuda:11.7.1-base-ubuntu20.04
BASE_DOCKER_FILE_PATH=${BASE_PATH}/${OS_PATH_NAME}/base
BASE_DOCKER_IMAGE_NAME="${IMAGE_NAME}"
BASE_DOCKER_IMAGE_VERSION="${CUDA_VERSION}-base-${OS}${OS_VERSION}"

# runtime image  : nvidia/cuda:11.7.1-runtime-ubuntu20.04
RUNTIME_DOCKER_FILE_PATH=${BASE_PATH}/${OS_PATH_NAME}/runtime
RUNTIME_DOCKER_IMAGE_NAME="${IMAGE_NAME}"
RUNTIME_DOCKER_IMAGE_VERSION="${CUDA_VERSION}-runtime-${OS}${OS_VERSION}"

# CUDNN runtime image  : nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
CUDNN_RUNTIME_DOCKER_FILE_PATH=${BASE_PATH}/${OS_PATH_NAME}/runtime/cudnn8
CUDNN_RUNTIME_DOCKER_IMAGE_NAME="${IMAGE_NAME}"
CUDNN_RUNTIME_DOCKER_IMAGE_VERSION="${CUDA_VERSION}-cudnn8-runtime-${OS}${OS_VERSION}"

# devel image    : nvidia/cuda:11.7.1-devel-ubuntu20.04
DEVEL_DOCKER_FILE_PATH=${BASE_PATH}/${OS_PATH_NAME}/devel
DEVEL_DOCKER_IMAGE_NAME="${IMAGE_NAME}"
DEVEL_DOCKER_IMAGE_VERSION="${CUDA_VERSION}-devel-${OS}${OS_VERSION}"

# CUDNN devel image    : nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
CUDNN_DEVEL_DOCKER_FILE_PATH=${BASE_PATH}/${OS_PATH_NAME}/devel/cudnn8
CUDNN_DEVEL_DOCKER_IMAGE_NAME="${IMAGE_NAME}"
CUDNN_DEVEL_DOCKER_IMAGE_VERSION="${CUDA_VERSION}-cudnn8-devel-${OS}${OS_VERSION}"

########################################################################################
# Docker Build Script Debug Tracing
########################################################################################
#BUILD_DEBUG=1 Turns shell command expansion on in Docker build scripts
#BUILD_DEBUG=0 Turns shell expandion off in Docker build scripts
BUILD_DEBUG=1

# Should Docker use Cache when building?
# - A couple of important reasons to DISABLE the use of the cache
#    - 1) You want to ensure you can build the image completey from scratch
#    - 2) The image build is failiing on an APT stage fetch
#         - Updates are made to repositories regularly and your apt-cache in the cached image may be stale
#         - This causes apt-get instructions to fail because the system has outdated information about a package
# To use cached images, set DOCKER_CACHE= ''
# To force rebuild, set DOCKER_CACHE='--no-cache'
# DOCKER_CACHE='--no-cache'
# Turn off use of cached images
#DOCKER_CACHE=''
DOCKER_CACHE='--no-cache'

# Location the build is executed from
DOCKER_BUILD_WORKING_DIR=`pwd`
DOCKER_BUILD_TMPDIR=$DOCKER_BUILD_WORKING_DIR/tmp

# Define File system error code
EX_OSFILE=72

TEST_PATH=`pwd`
