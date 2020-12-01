#!/bin/bash
########################################################################################
# Docker Image Build Variable Customization/Configuration:
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/17/2020
#
########################################################################################
# Override Dockerfile Build Arguments:
########################################################################################

# Override Xilinx tool information
XLNX_TOOL_INFO=petalinux

# Xilinx Release Information
XLNX_RELEASE_VERSION=v2019.2

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

# Petalinux Location information
XLNX_PETALINUX_INSTALL_DIR=$XLNX_INSTALL_LOCATION/petalinux/$XLNX_RELEASE_VERSION

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
# Xilinx ARM Mali Pre-built binaries
# DOCKER_BUILD_INCLUDE_XLNX_MALI:
# '0' = The docker build script will NOT include the MALI binaries in the resulting image
#
# '1' = The docker build script will include the MALI binaries in the resulting image
#       using the python server address to transfer the archive to the docker build
DOCKER_BUILD_INCLUDE_XLNX_MALI=0

XLNX_MALI_URL=0.0.0.0:8000
XLNX_MALI_BINARY=$INSTALL_DEPENDS_DIR/mali-400-userspace.tar
#XLNX_MALI_BINARY=$INSTALL_DEPENDS_DIR/mali-400-userspace-with-android-2019.1.tar

# Xilinx Petalinux Autoinstall Script
#  for headless installation of Petalinux
XLNX_PETALINUX_AUTOINSTALL_SCRIPT=autoinstall_petalinux.sh

# Xilinx Petalinux Installer Bundle
XLNX_PETALINUX_INSTALLER=$INSTALL_DEPENDS_DIR/petalinux-v2019.2-final-installer.run

########################################################################################
########################################################################################