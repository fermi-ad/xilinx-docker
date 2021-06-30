#!/bin/bash
########################################################################################
# Docker Image Build Variable Customization/Configuration:
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 6/30/2021
#
########################################################################################
# Override Dockerfile Build Arguments:
########################################################################################

# Xilinx Release Information
XLNX_RELEASE_VERSION=v2021.1

# Xilinx tool information
XLNX_TOOL_INFO=vivado
XLNX_TOOL_INSTALLER_NAME=Vivado

# Docker File Recipe Target Stage
DOCKER_FILE_STAGE=xilinx_install_$XLNX_TOOL_INFO"_"$XLNX_RELEASE_VERSION

# Docker Target Image Information
DOCKER_IMAGE_NAME=xilinx-$XLNX_TOOL_INFO
DOCKER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

# Docker User Image Information
DOCKER_USER_IMAGE_VERSION=$XLNX_RELEASE_VERSION
DOCKER_USER_IMAGE_NAME=xilinx-$BASE_OS_NAME-$BASE_OS_VERSION-user

# Location the build is executed from
DOCKER_BUILD_WORKING_DIR=`pwd`
DOCKER_BUILD_TMPDIR=$DOCKER_BUILD_WORKING_DIR/tmp

########################################################################################
########################################################################################
# Target Path Variables for Docker Image:
########################################################################################
########################################################################################
# Xilinx Tool Install Location
XLNX_INSTALL_LOCATION=/opt/Xilinx

# Xilinx Tool Default Downloads Location
XLNX_DOWNLOAD_LOCATION=/tools/Xilinx/Downloads/2021.1

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
XLNX_UNIFIED_INSTALLER_BASENAME=Xilinx_Unified_2021.1_0610_2318
XLNX_UNIFIED_WEB_INSTALLER=$INSTALL_DEPENDS_DIR/${XLNX_UNIFIED_INSTALLER_BASENAME}_Lin64.bin

# Xilinx Unified Pre-downloaded offline install bundle
# - This is downloaded and created by:
#   1. Running the web-installer with the batch mode configuration
#   2. Downloading the files for offline install
#   3. Manually archiving files in a tarball
XLNX_UNIFIED_FULL_INSTALLER=$INSTALL_DEPENDS_DIR/${XLNX_UNIFIED_INSTALLER_BASENAME}.tar.gz
#XLNX_UNIFIED_OFFLINE_INSTALLER=${XLNX_UNIFIED_WEB_INSTALLER}.tar.gz
XLNX_UNIFIED_OFFLINE_INSTALLER=${XLNX_UNIFIED_FULL_INSTALLER}

########################################################################################
########################################################################################