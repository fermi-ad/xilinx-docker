# Dockerfile.vitis_v2019.2
########################################################################################
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Updates:
#	- 3/24/2020: Add xilinx user to dialout group, install minicom to use /dev/ttyUSB* devices from shell
#
# Created: 
#	- 12/17/2019
#
# What's installed in the image created by this docker file?
# ----------------------------------------------------------
# - Ubuntu 18.04.2 x64 base OS image
# - Xilinx Vitis v2019.2 (Xilinx Vitis v2019.2 release)
#
#
# Multi-stage build organization:
# -------------------------------
# 1. base_os_vitis_v2019.2							: Base Ubuntu 16.04.5/18.04.1 image with a few basics, locale setup and user account
# 2. |___ xilinx_install_depends_vitis_v2019.2		: +Xilinx specific install dependencies
# 3.      |___ xilinx_install_vitis_v2019.2				: +Xilinx Tool Installation
########################################################################################
# Base OS Image:
# --------------
#	- Ubuntu 18.04.2
#		- start with the base Ubuntu 18.04.2 build from Ubuntu release tarballs
########################################################################################
FROM ubuntu:18.04.2 AS base_os_vitis_v2019.2
LABEL author="Jason Moss"

# Address build bug: https://github.com/docker/docker/issues/4032
ENV DEBIAN_FRONTEND=noninteractive

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
# Configure APT to ignore recommended or suggested packages by default to keep the final image small \
	&& echo "APT::Install-Recommends false;" > /etc/apt/apt.conf.d/00norecommends \
	&& echo "APT::AutoRemove::RecommendsImportant false;" >> /etc/apt/apt.conf.d/00norecommends \
	&& echo "APT::Install-Suggests false;" > /etc/apt/apt.conf.d/00nosuggests \
	&& echo "APT::AutoRemove::SuggestsImportant false;" >> /etc/apt/apt.conf.d/00nosuggests \
	&& apt-get update \
# Install apt-utils which is needed by debconf for some of the other packages being installed \
	&& apt-get install -y \
		apt-utils \
# Install vim for local file editing \
		vim \
# Install and setup locale \
	&& apt-get install locales \
	&& locale-gen en_US.UTF-8 \
	&& dpkg-reconfigure \
		--frontend $DEBIAN_FRONTEND locales

# Install debconf-utils, dialog \
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& apt-get install -y \
		dialog \
		debconf-utils \
# Put debconf in non interactive mode \
	&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Create a user account with no password and add user to sudoers
# Install sudo and setup a user account, which is essential for Yocto and other tools
# adduser command:  http://manpages.ubuntu.com/manpages/xenial/man8/adduser.8.html
# Arguments can be filled at build time using the '--build-arg' option
ARG USER_ACCT
ARG HOME_DIR
ARG XLNX_INSTALL_LOCATION

RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& apt-get install -y \
		sudo \
	&& adduser \
		--disabled-password \
		--gecos '' \
		--shell /bin/bash \
		--home $HOME_DIR \
		$USER_ACCT \
	&& echo \
		"$USER_ACCT ALL=(ALL) NOPASSWD: ALL" \
		>> /etc/sudoers \
# Add user to the dialout group for serial port access \
	&& adduser $USER_ACCT dialout \
# Create the Xilinx install folder and add appropriate permissions \
	&& mkdir -p $XLNX_INSTALL_LOCATION \
	&& chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
# Set BASH as the default shell \
	&& echo "dash dash/sh boolean false" | debconf-set-selections \
	&& DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

########################################################################################
# Xilinx Vitis Dependencies:
# ---------------------------
# - Includes Petalinux Dependencies and JRE needed for Eclipse in XSDK
########################################################################################
FROM base_os_vitis_v2019.2 AS xilinx_install_depends_vitis_v2019.2
LABEL author="Jason Moss"

# Re-use previous stage ARG
ARG USER_ACCT
ARG HOME_DIR

# Switch to the user account, dump group configuration
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_INSTALL_LOCATION
ARG XLNX_PETALINUX_INSTALLER
ARG INSTALL_SERVER_URL

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Setup install location folder permissions
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
# add i386 architecture for zlib1g-dev dependency \
	&& sudo dpkg --add-architecture i386 \
	&& sudo apt-get update \
	&& sudo apt-get install -y \
# vitis base dependencies - UG1400 \
     ocl-icd-dev \
     ocl-icd-libopencl1 \
     opencl-headers \
     ocl-icd-opencl-dev \
# undocumented vitis dependencies \
# GTK is required by the Eclipse Standard Widget Toolkit (SWT) \
	 libgtk2.0-0 \
# petalinux-gblibc-x86_64-petalinux-image-minimal-aarch64-toolchain.sh requires this in post install
	 gcc \
# Install Vivado dependencies from ldd-recursive.pl in AR#66184 \
# - See: https://www.xilinx.com/support/answers/66184.html \
	 libboost-signals-dev \
	 google-perftools \
# Undocumented Vivado Depdencies \
	 less \
	 fakeroot \
	 xorg \
	 make \
# Non-required packages for productivity \
	 tofrodos \
	 dos2unix \
	 iproute2 \
	 gawk \
	 git \
	 wget \
	 diffstat \
	 xterm \
	 xvfb \
	 tar \
	 unzip \
	 gzip \
	 less \
# Add minicom for /dev/ttyUSB* access from command line \
	 minicom

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Setup GIT with a dummy username and email address
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& git config \
	--global user.name $GIT_USER_NAME \
	&& git config \
	--global user.email $GIT_USER_EMAIL \
	&& git config \
	--global color.ui true

########################################################################################
# Download Xilinx Unified Web Installer
# - Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
#	- Xilinx Unified Installer v2019.2
#		- Download Link: 
#			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2019.2_1106_2127_Lin64.bin
#		- Release Notes;
#			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis-design-tools/2019-2.html
#			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vitis-release-notes-install-license.pdf
# - Place the installer binary (or a link to it) in the ./depends folder
# - Vitis v2019.2 Release Notes:
#	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk300137739.html
#
# Download the Xilinx Runtime (XRT)
# - The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
#	- Pre-built XRT Ubuntu 18.04 Package for v2019.2
#		- Installation Instructions:
#			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#pjr1542153622642
#		- Download Link:
#			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_18.04-xrt.deb
########################################################################################
FROM xilinx_install_depends_vitis_v2019.2 AS xilinx_install_vitis_v2019.2
LABEL author="Jason Moss"

# Re-use previous stage ARG
ARG USER_ACCT
ARG HOME_DIR

# Switch to the user account
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_INSTALL_LOCATION
ARG XLNX_DOWNLOAD_LOCATION
ARG INSTALL_SERVER_URL

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Arguments can be filled at build time using the '--build-arg' option
ARG KEYBOARD_CONFIG_FILE
ARG XTERM_CONFIG_FILE
ARG MINICOM_CONFIG_FILE

# Configure the Keyboard (not required for Unified installation, but needed for SDK)
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& export TERM=xterm \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
# Get Keyboard configuration file \
	&& mkdir -p "${KEYBOARD_CONFIG_FILE%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$KEYBOARD_CONFIG_FILE -O $KEYBOARD_CONFIG_FILE \
	&& cat $KEYBOARD_CONFIG_FILE \
# Configure Keyboard silently \
	&& sudo DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt-get install -y keyboard-configuration \
	&& sudo DEBIAN_FRONTEND=$DEBIAN_FRONTEND debconf-set-selections < $KEYBOARD_CONFIG_FILE \
	&& sudo DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure keyboard-configuration \
# Configure Xterm to change the color scheme and allow copy-paste with host \
	&& mkdir -p "${XTERM_CONFIG_FILE%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$XTERM_CONFIG_FILE -O $XTERM_CONFIG_FILE \
	&& cat $XTERM_CONFIG_FILE \
	&& cp $XTERM_CONFIG_FILE $HOME_DIR \
# Copy Minicom configuration file \
	&& mkdir -p "${MINICOM_CONFIG_FILE%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$MINICOM_CONFIG_FILE -O $MINICOM_CONFIG_FILE \
	&& cat $MINICOM_CONFIG_FILE \
	&& cp $MINICOM_CONFIG_FILE $HOME_DIR

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_UNIFIED_OFFLINE_INSTALLER
ARG XLNX_UNIFIED_BATCH_CONFIG_FILE

# Get the Unified installer
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
 	&& cd $XLNX_INSTALL_LOCATION/tmp \
# Get Xilinx Unified Installer Batch Mode configuration file \
 	&& mkdir -p "${XLNX_UNIFIED_BATCH_CONFIG_FILE%/*}" \
 	&& wget -nv $INSTALL_SERVER_URL/$XLNX_UNIFIED_BATCH_CONFIG_FILE -O $XLNX_UNIFIED_BATCH_CONFIG_FILE \
 	&& cat $XLNX_UNIFIED_BATCH_CONFIG_FILE \
# Get Xilinx Unified Installer Offline Installer \
 	&& mkdir -p "${XLNX_UNIFIED_OFFLINE_INSTALLER%/*}" \
 	&& wget -nv --no-cache $INSTALL_SERVER_URL/$XLNX_UNIFIED_OFFLINE_INSTALLER -O $XLNX_UNIFIED_OFFLINE_INSTALLER \
	&& chmod a+x $XLNX_UNIFIED_OFFLINE_INSTALLER \
# Decompress Unified Installer \
 	&& tar -zxf $XLNX_UNIFIED_OFFLINE_INSTALLER && ls -al \
# Have new user shell start in Xilinx tool folder \
	&& echo "cd $XLNX_INSTALL_LOCATION" >> $HOME_DIR/.bashrc \
# Setup the User Locale \
# Xilinx tools specifically require the 'en_US.UTF-8' locale \
	&& echo "export LANG=en_US.UTF-8" >> $HOME_DIR/.bashrc \
	&& export "LANG=en_US.UTF-8" \
# Setup bashrc to source petalinux settings on login \
	&& echo ". $XLNX_INSTALL_LOCATION/Vitis/2019.2/settings64.sh" >> $HOME_DIR/.bashrc \
# Setup LD_LIBRARY_PATH to include Unified included Linux libraries \
	&& echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XLNX_INSTALL_LOCATION/Unified/2019.2/lib/lnx64.o/" >> $HOME_DIR/.bashrc \
# Setup installer permissions \
  	&& chmod a+x xsetup \
	&& sudo apt-get install -y \
# undocumented vitis post install dependencies \
		xz-utils \
# Run Setup in batch mode to install Unified \
	&& ./xsetup \
  		--agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  		--config $XLNX_UNIFIED_BATCH_CONFIG_FILE \
  		--batch INSTALL \
# Cleanup Temporary Files \
  	&& cd $HOME_DIR \
  	&& rm -rf $XLNX_INSTALL_LOCATION/tmp

# Cleanup apt cache and temporary files to reduce image size
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
# Print information about users \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections