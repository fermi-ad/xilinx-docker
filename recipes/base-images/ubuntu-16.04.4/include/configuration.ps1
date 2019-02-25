# CONVERTED ORIGINAL BASH SCRIPT TO WINDOWS POWERSHELL SYNTAX
########################################################################################
# Docker Image Build Variable Custom Configuration:
#   - Customize definitions of arguments for building images for v2018.3
#   - Used with: Dockerfile.xx_v2018.3
#   - Create a base ubuntu image from a specific release tarball
#   - Base image tarballs for older releases can be found in the cdimage archive:
#       Link: http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/
#
# Maintainer:
#   - Jason Moss (jason.moss@avnet.com)
#   - Xilinx Applications Engineer, Embedded Software
#
# Created: 
#   - 2/4/2019
#
########################################################################################
# Docker Build Script Debug Tracing
########################################################################################
#BUILD_DEBUG=1 Turns shell command expansion on in Docker build scripts
#BUILD_DEBUG=0 Turns shell expandion off in Docker build scripts
$BUILD_DEBUG = 1

# Ubuntu Revision (Xenial Xaurus) v16.04.4
# Source configuration for v2018.3 builds
$UBUNTU_BASE_URL = "http://cdimage.ubuntu.com/ubuntu-base/releases"
$UBUNTU_VERSION = "16.04.4"

$UBUNTU_RELEASE_ARCHIVE = "ubuntu-base-16.04.4-base-amd64.tar.gz"