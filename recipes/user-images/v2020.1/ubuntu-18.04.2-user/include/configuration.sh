#!/bin/bash
########################################################################################
# Docker Image Build Variable Custom Configuration:
#   - Customize definitions of arguments for building images for ubuntu 18.04.1 userimage
#	- Used with: Dockerfile
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 7/6/2020
#
########################################################################################
# Docker Build Script Debug Tracing
########################################################################################
#BUILD_DEBUG=1 Turns shell command expansion on in Docker build scripts
#BUILD_DEBUG=0 Turns shell expandion off in Docker build scripts
BUILD_DEBUG=1

########################################################################################
# Override Dockerfile Build Arguments:
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

# Docker base OS Images
DOCKER_BASE_OS=ubuntu
DOCKER_BASE_OS_TAG=18.04.2

# Xilinx Release Information
XLNX_RELEASE_VERSION=v2020.1

# Xilinx tool information
XLNX_TOOL_INFO=ubuntu-$DOCKER_BASE_OS_TAG-user

# Docker File Recipe Name
# Petalinux - possible stage assignments
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

# Docker build image parameters
DOCKER_IMAGE_VERSION=$XLNX_RELEASE_VERSION

########################################################################################
########################################################################################
# Target Path Variables for Docker Image:
########################################################################################
########################################################################################
# Xilinx Tool Install Location
XLNX_INSTALL_LOCATION=/opt/Xilinx

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

# Configuration Files for minicom session inside of the docker container
# MINICOM_CONFIG_FILE: Minicom default settings configuration file
#   115200-8-N-1, no hardware flow control by default
MINICOM_CONFIG_FILE=$INSTALL_CONFIGS_DIR/.minirc.dfl

# Local Python3 http server to transfer files into container
# INSTALL_SERVER_URL: Set automatically later in this script when
#	http server is spawned for file transfer to container
INSTALL_SERVER_URL=0.0.0.0:8000

########################################################################################
########################################################################################

# Define File system error code
EX_OSFILE=72