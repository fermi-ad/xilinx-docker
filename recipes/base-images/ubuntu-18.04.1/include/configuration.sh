#!/bin/bash
########################################################################################
# Docker Image Build Variable Custom Configuration:
#   - Customize definitions of arguments for building images for v2019.1
#	- Used with: Dockerfile.xx_v2019.1
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 6/22/2019
#
########################################################################################
# Docker Build Script Debug Tracing
########################################################################################
#BUILD_DEBUG=1 Turns shell command expansion on in Docker build scripts
#BUILD_DEBUG=0 Turns shell expandion off in Docker build scripts
BUILD_DEBUG=1

# Ubuntu Revision (Xenial Xaurus) v18.04.1
# Source configuration for v2019.1 builds
UBUNTU_BASE_URL=http://cdimage.ubuntu.com/ubuntu-base/releases
UBUNTU_VERSION=18.04.1

UBUNTU_RELEASE_ARCHIVE=ubuntu-base-18.04.1-base-amd64.tar.gz