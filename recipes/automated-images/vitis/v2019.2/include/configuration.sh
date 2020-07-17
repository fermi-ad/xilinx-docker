#!/bin/bash
########################################################################################
# Docker Image Build Variable Custom Configuration:
#   - Customize definitions of arguments for building images for v2019.2
#	- Used with: Dockerfile.xx_v2019.2
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 7/16/2020
#
#######################################################################################
# Docker Build Script Debug Tracing
########################################################################################
#BUILD_DEBUG=1 Turns shell command expansion on in Docker build scripts
#BUILD_DEBUG=0 Turns shell expandion off in Docker build scripts
BUILD_DEBUG=1

########################################################################################
########################################################################################
# DOCKER FILE GENERAL CONFIGURATION PARAMETERS:
########################################################################################
########################################################################################
# User account information
# USER_ACCT: user account name within docker image
# HOME_DIR : user account home directory
USER_ACCT=xilinx
HOME_DIR=/home/$USER_ACCT

# GIT Configuration
# GIT_USER_NAME: Username for git configuration
# GIT_USER_EMAIL: email address for git configuration
GIT_USER_NAME="Xilinx User"
GIT_USER_EMAIL="Xilinx.User@dummyaddress.com"

# Xilinx Release Information
XLNX_RELEASE_VERSION=v2019.2

# Xilinx tool information
XLNX_TOOL_INFO=vitis
XLNX_TOOL_INSTALLER_NAME=Vitis

# Docker File Recipe Name
# Dockerfile - possible stage assignments
#DOCKER_FILE_NAME=Dockerfile.$XLNX_TOOL_INFO_$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=base_os_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=xilinx_install_depends_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=xilinx_install_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
DOCKER_FILE_STAGE=xilinx_install_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION

# Docker Image Name
DOCKER_IMAGE_NAME=xilinx-$XLNX_TOOL_INFO

# Docker base OS Images
DOCKER_BASE_OS=ubuntu
DOCKER_BASE_OS_TAG=18.04.2

DOCKER_USER_IMAGE_NAME=xilinx-ubuntu-18.04.2-user
DOCKER_USER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

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
#DOCKER_CACHE='--no-cache'
DOCKER_CACHE=''

# Location the build is executed from
DOCKER_BUILD_WORKING_DIR=`pwd`
DOCKER_BUILD_TMPDIR=$DOCKER_BUILD_WORKING_DIR/tmp

# Docker build image parameters
DOCKER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

########################################################################################
########################################################################################
# Target Path Variables for Docker Image:
########################################################################################
########################################################################################
# Xilinx Tool Install Location
XLNX_INSTALL_LOCATION=/opt/Xilinx

# Xilinx Tool Downloads Location
XLNX_DOWNLOAD_LOCATION=$XLNX_INSTALL_LOCATION/downloads

########################################################################################
########################################################################################
# Host OS Path Variables for Docker build:
########################################################################################
########################################################################################
DOCKER_INSTALL_DIR=.

# Xilinx Configuration and Dependency folder definitions
# These locations must be within the docker build context
# (meaning accessible from the base folder of the Dockerfile)
# INSTALL_CONFIGS_DIR: folder in docker context on host for
#	build related configuration files for headless install
# INSTALL_DEPENDS_DIR:  folder in docker context on host for
#	build related installers/downloads used in installation
INSTALL_CONFIGS_DIR=configs
INSTALL_DEPENDS_DIR=depends

########################################################################################
########################################################################################
# Depdendency / Configuration File Related Variables
########################################################################################
########################################################################################
# Xilinx Unified Installer batch mode: Batch mode install configuration template
#	for headless install of Xilinx Tool components
XLNX_UNIFIED_BATCH_CONFIG_FILE=$INSTALL_CONFIGS_DIR/xlnx_unified_$XLNX_TOOL_INFO.config

# Xilinx Unified Web-based installer
XLNX_UNIFIED_WEB_INSTALLER=$INSTALL_DEPENDS_DIR/Xilinx_Unified_2019.2_1024_1831_Lin64.bin

# Xilinx Unified Pre-downloaded offline install bundle
# - This is downloaded and created by:
#   1. Running the web-installer with the batch mode configuration
#   2. Downloading the files for offline install
#   3. Manually archiving files in a tarball
XLNX_UNIFIED_OFFLINE_INSTALLER=$INSTALL_DEPENDS_DIR/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz

# Xilinx XRT Binary Information
# XRT Binaries are installed locally on the HOST, Not the container
# - The release Ubuntu 18.04 Package is installed
# - The GIT repository is also cloned locally in the container
#   for easy access should XRT need to be rebuilt or debugged
#
# Dependency Install Script for Ubuntu/CentOS
XLNX_XRT_DEPENDENCY_SCRIPT=https://raw.githubusercontent.com/Xilinx/XRT/2019.2/src/runtime_src/tools/scripts/xrtdeps.sh

# Pre-built Installer file for Ubuntu 18.04
XLNX_XRT_PREBUILT_INSTALLER=$INSTALL_DEPENDS_DIR/xrt_201920.2.3.1301_18.04-xrt.deb

# Xilinx XRT Repository
XLNX_XRT_GIT_REPO="https://github.com/Xilinx/XRT.git"
XLNX_XRT_GIT_BRANCH="2019.2"

# Local Python3 http server to transfer files into container
# INSTALL_SERVER_URL: Set automatically later in this script when
#	http server is spawned for file transfer to container
INSTALL_SERVER_URL=0.0.0.0:8000

########################################################################################
########################################################################################

# Define File system error code
EX_OSFILE=72




