#!/bin/bash
########################################################################################
# Docker Image Build Variable Customization/Configuration:
#
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 9/23/2021
#
########################################################################################
# Override Dockerfile Build Arguments:
########################################################################################

# Path definitions
DOWNLOAD_PATH=depends
TMP_PATH=tmp

# Ubuntu specific
BASE_OS_NAME=ubuntu
BASE_OS_VERSION=20.04.3
BASE_OS_CODENAME=focal
BASE_OS_ARCH=amd64

# Ubuntu Revision (Focal Fossa) 20.04.3
# Base Tarball Image
BASE_RELEASE_URL=http://cdimage.ubuntu.com/ubuntu-base/releases/$BASE_OS_VERSION/release
BASE_RELEASE_IMAGE=$BASE_OS_NAME-base-$BASE_OS_VERSION-base-$BASE_OS_ARCH.tar.gz
BASE_RELEASE_CHECKSUM_TYPE=sha256 #sha256, ...
BASE_RELEASE_CHECKSUM_FILE=SHA256SUMS

# Server ISO Image
# In 20.04, non "live" installers are hosted in a different location
ISO_RELEASE_URL=http://releases.ubuntu.com/releases/$BASE_OS_VERSION
#ISO_RELEASE_IMAGE=$BASE_OS_NAME-$BASE_OS_VERSION-server-$BASE_OS_ARCH.iso
ISO_RELEASE_IMAGE=$BASE_OS_NAME-$BASE_OS_VERSION-live-server-$BASE_OS_ARCH.iso
#ISO_RELEASE_URL=http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/$BASE_OS_VERSION/release/
#ISO_RELEASE_IMAGE=$BASE_OS_NAME-$BASE_OS_VERSION-legacy-server-$BASE_OS_ARCH.iso
ISO_RELEASE_CHECKSUM_TYPE=sha256 #sha256, ...
ISO_RELEASE_CHECKSUM_FILE=SHA256SUMS
ISO_RELEASE_SQUASHFS_IMAGE=casper/filesystem.squashfs

# Desktop ISO Image (Alternate Definitions)
#ISO_RELEASE_URL=http://old-releases.ubuntu.com/releases/$BASE_OS_VERSION
#ISO_RELEASE_IMAGE=$BASE_OS_NAME-$BASE_OS_VERSION-desktop-$BASE_OS_ARCH.iso
#ISO_RELEASE_URL=http://releases.ubuntu.com/releases/$BASE_OS_VERSION
#ISO_RELEASE_IMAGE=$BASE_OS_NAME-$BASE_OS_VERSION-desktop-$BASE_OS_ARCH.iso
#ISO_RELEASE_CHECKSUM_TYPE=sha256 #sha256, ...
#ISO_RELEASE_CHECKSUM_FILE=SHA256SUMS
#ISO_RELEASE_SQUASHFS_IMAGE=casper/filesystem.squashfs

# Temporary Variables for ISO image processing
ROOTFS_TMPDIR=$TMP_PATH/rootfs
SQUASHFS_TMPDIR=$TMP_PATH/unsquashfs

# Define an array of image information (for download purposes)
# [0]: Base URL
# [1]: Filename
# [2]: Checksum type
# [3]: Checksum filename

declare -A image_url
declare -A image_file
declare -A image_checksum_type
declare -A image_checksum_file

# Define File system error code
EX_OSFILE=72