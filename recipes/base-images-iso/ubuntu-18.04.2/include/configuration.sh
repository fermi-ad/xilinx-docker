#!/bin/bash
########################################################################################
# Docker Image Build Variable Custom Configuration:
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/17/2020
#
########################################################################################
# Docker Build Script Debug Tracing
# This has been moved to a command line argument in build script
########################################################################################

# Ubuntu Revision (Xenial Xaurus) v18.04.2
# Source configuration for v2018.3 builds
UBUNTU_VERSION=18.04.2
UBUNTU_BASE_URL=http://old-releases.ubuntu.com/releases/${UBUNTU_VERSION}/

UBUNTU_RELEASE_ARCHIVE=ubuntu-${UBUNTU_VERSION}-server-amd64.iso
#UBUNTU_RELEASE_ARCHIVE=ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso

UBUNTU_RELEASE_CHECKSUM_TYPE=sha256 #possible values: sha256, ...
UBUNTU_RELEASE_CHECKSUM_FILE=SHA256SUMS

# Temporary Variables
ROOTFS_TMPDIR=tmp/rootfs
SQUASHFS_TMPDIR=tmp/unsquashfs
# Squashfs filesystem for desktop ISO
#SQUASHFS_IMG=casper/filesystem.squashfs
# Squashfs filesystem for server ISO
SQUASHFS_IMG=install/filesystem.squashfs

# Define File system error code
EX_OSFILE=72