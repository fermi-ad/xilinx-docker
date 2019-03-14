#!/bin/bash
########################################################################################
# Docker Image Build Variable Custom Configuration:
#   - Customize definitions of arguments for building images for v2018.3
#	- Used with: Dockerfile.xx_v2018.3
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 1/22/2019
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
XLNX_RELEASE_VERSION=v2018.3

# Xilinx tool information
XLNX_TOOL_INFO=yocto

# Docker File Recipe Name
# Vivado - possible stage assignments
#DOCKER_FILE_NAME=Dockerfile.$XLNX_TOOL_INFO_$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=base_os_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=xilinx_install_depends_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
#DOCKER_FILE_STAGE=xilinx_install_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION
DOCKER_FILE_STAGE=xilinx_install_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION

# Docker Image Name
#DOCKER_IMAGE_NAME=xilinx-yocto
#DOCKER_IMAGE_NAME=xilinx-vivado
#DOCKER_IMAGE_NAME=xilinx-petalinux
DOCKER_IMAGE_NAME=xilinx-$XLNX_TOOL_INFO

# Docker base OS Images
DOCKER_BASE_OS=ubuntu
DOCKER_BASE_OS_TAG=18.04.2

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
DOCKER_CACHE='--no-cache'

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

# Yocto information
# YOCTO_DIR: base yocto installation directory
# YOCTO_VER: yocto version (xilinx nomenclature)
# YOCTO_MANIFEST_URL: The yocto manifest repository
# YOCTO_MANIFEST_BRANCh: What branch to sync from the repository
YOCTO_VER=$XLNX_RELEASE_VERSION
YOCTO_DIR=$XLNX_INSTALL_LOCATION/yocto/$YOCTO_VER
YOCTO_MANIFEST_URL=git://github.com/Xilinx/yocto-manifests.git
YOCTO_MANIFEST_BRANCH=rel-v2018.3

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
# DOCKER_BUILD_XLNX_MALI_LOCAL:
# '0' = The docker build script will not construct XLNX_MALI_URL
#       using the python server address, but will pass the URL setup above
#
# '1' = The docker build scrpit will construct XLNX_MALI_URL
#		using the python server address and the INSTALL_DEPENDS_DIR variable
DOCKER_BUILD_XLNX_MALI_LOCAL='1'

# Xilinx ARM Mali Pre-built binaries
# XLNX_MALI_URL: Base download URL
# XLNX_MALI_BINARY: filename to download
# Set #1: Download MALI binary directly from Xilinx
# DOCKER_BUILD_XLNX_MALI_LOCAL=0
#XLNX_MALI_URL=https://www.xilinx.com/publications/products/tools
#XLNX_MALI_BINARY=mali-400-userspace.tar
# Set #2: Download from local archive by use of python http.server (address set later in this script)
# DOCKER_BUILD_XLNX_MALI_LOCAL=1
XLNX_MALI_URL=0.0.0.0:8000
XLNX_MALI_BINARY=$INSTALL_DEPENDS_DIR/mali-400-userspace.tar

# Configuration Files for batch mode installation
# KEYBOARD_CONFIG_FILE:	Keyboard setting configuration file
#	for headless selection of the keyboard setup
#	Required for the X-based XSDK installer package
KEYBOARD_CONFIG_FILE=$INSTALL_CONFIGS_DIR/keyboard_settings.conf

# Configuration file for xterm sessions inside of the docker container
# XTERM_CONFIG_FILE: XTerm session configuratino file
#	Changes color scheme and font to something more readable (default is white background)
#   Changes scrollback to 1 million lines and enables the scroll bar
#   Notes on Copy-Paste with the host:
#	 	Copy from Host to XTerm:
#			- Host may copy with "CTRL-C" or "Right-Click->Copy"
#			- Use center mouse button (scroll wheel) to paste into XTerm session
#
#		Copy from XTerm to Host:
#			- Select text in XTerm session to copy using cursor (left-click and drag over text to copy)
#			- Host may paste with center mouse button (scroll wheel)
#			- Host clipboard contents from host copy maintained in separate buffer (CTRL-V)
#-------------
XTERM_CONFIG_FILE=$INSTALL_CONFIGS_DIR/XTerm

# XLNX_XSDK_BATCH_CONFIG_FILE: Batch mode install configuration template
#	for headless install of Xilinx SDK components
# xsdk_config_xsct_only.config = XSCT only installation
# xsdk_config_xsdk_full.config = XSDK full installation
# Note: XSCT is used for Yocto
#XLNX_XSDK_BATCH_CONFIG_FILE=$INSTALL_CONFIGS_DIR/xsdk_config_xsdk_full.config
XLNX_XSDK_BATCH_CONFIG_FILE=$INSTALL_CONFIGS_DIR/xsdk_config_xsct_only.config

# Xilinx SDK Web-based installer
# XLNX_XSDK_WEBINSTALLER: Official web-based installer for the SDK release
XLNX_XSDK_WEB_INSTALLER=$INSTALL_DEPENDS_DIR/Xilinx_SDK_2018.3_1207_2324_Lin64.bin

# Xilinx SDK Pre-downloaded offline install bundle
# - This is downloaded and created by:
#   1. Running the web-installer with the batch mode configuration
#   2. Downloading the files for offline install
#   3. Manually archiving files in a tarball
XLNX_XSDK_OFFLINE_INSTALLER=$INSTALL_DEPENDS_DIR/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz

# Local Python3 http server to transfer files into container
# INSTALL_SERVER_URL: Set automatically later in this script when
#	http server is spawned for file transfer to container
INSTALL_SERVER_URL=0.0.0.0:8000

########################################################################################
########################################################################################

# Define File system error code
EX_OSFILE=72




