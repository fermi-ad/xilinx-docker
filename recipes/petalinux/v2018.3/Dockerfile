# Dockerfile.petalinux_v2018.3
########################################################################################
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 12/13/2018
# 
# What's installed in the image created by this docker file?
# ----------------------------------------------------------
# - Ubuntu 16.04.3 x64 base OS image
# - Xilinx Petalinux v2018.3 (Xilinx Petalinux v2018.3 release)
#
#
# Multi-stage build organization:
# -------------------------------
# 1. base_os_petalinux_v2018.3						: Base Ubuntu 16.04.3 image with a few basics, locale setup and user account
# 2. |___ xilinx_install_depends_petalinux_v2018.3	: +Xilinx specific install dependencies
# 3.      |___ xilinx_install_petalinux_v2018.3		: +Xilinx Tool Installation
########################################################################################
# Base OS Image:
# --------------
#	- Ubuntu 16.04.3
#		- start with the base Ubuntu 16.04.3 build from Ubuntu release tarballs
########################################################################################
FROM ubuntu:16.04.3 AS base_os_petalinux_v2018.3
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
# Create the Xilinx install folder and add appropriate permissions \
	&& mkdir -p $XLNX_INSTALL_LOCATION \
	&& chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
# Set BASH as the default shell \
	&& echo "dash dash/sh boolean false" | debconf-set-selections \
	&& DEBIAN_FRONTEND=$DEBIAN_FRONTEND dpkg-reconfigure dash

########################################################################################
# Xilinx Petalinux Dependencies:
# ---------------------------
########################################################################################
FROM base_os_petalinux_v2018.3 AS xilinx_install_depends_petalinux_v2018.3
LABEL author="Jason Moss"

# Re-use previous stage ARG
ARG USER_ACCT
ARG HOME_DIR

# Switch to the user account
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
# petalinux base dependencies \
	&& sudo apt-get install -y \
	  	tofrodos \
	  	iproute2 \
		gawk \
		xvfb \
		git \
		make \
		net-tools \
		libncurses5-dev \
# Install update-inetd for tftpd \
	  	update-inetd \
	  	tftpd \
		zlib1g-dev:i386 \
	  	libssl-dev \
	  	flex \
	  	bison \
	  	libselinux1 \
	  	gnupg \
	  	wget \
		diffstat \
		chrpath \
		socat \
		xterm \
		autoconf \
		libtool \
		libtool-bin \
# Use BSDTAR vs.  TAR due to issues in docker container \
		tar \
#		bsdtar \
	  	unzip \
	  	texinfo \
		zlib1g-dev \
		gcc-multilib \
		build-essential \
		libsdl1.2-dev \
		libglib2.0-dev \
		screen \
		pax \
		gzip \
# python3-gi is used by bitbake's dependency explorer \
		python3-gi \
# undocumented dependencies \
		less \
		lsb-release \
		fakeroot \
		libgtk2.0-0 \
		libgtk2.0-dev \
# yocto depedencies (for petalinux) \
		cpio \
		rsync \
		xorg \
# dependency for autoinstall of petalinux \
		expect \
# used to strip windows line terminations from autoinstall scripts in powershell \
		dos2unix
# Already Installed \
#		sudo \
#		locales \
#		git

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
#	- Xilinx Petalinux Installer
#		- Download Link:
#			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2018.3-final-installer.run
#		- Release Notes:
#			- https://www.xilinx.com/support/answers/71201.html
#			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk.html
#
#	- Xilinx ARM MALI GPU Binaries
#		- Download Link:
#			- https://www.xilinx.com/publications/products/tools/mali-400-userspace.tar
#		- Release Notes:
#			- http://www.wiki.xilinx.com/Adding+MALI+userspace+binaries+in+Yocto+builds
#			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
#
#	- Keyboard Configuration
#		- Xilinx Petalinux Installer is X11-based and requires a valid keyboard configuration
#		- Requires
#			- keyboard-configuration
#			- debconf-utils
#		- Run the following commands to generate a keyboard configuration interactively:
#			- $ sudo dpkg-reconfigure keyboard-configuration 
#		- Extract the keyboard configuration to a file
#			- $ debconf-get-selections | grep keyboard-configuration > keyboard_settings.conf
#		- Import these in 'headless' mode
#			- $ debconf-set-selections < keyboard_settings.conf
#			- $ dpkg-reconfigure keyboard-configuration -f noninteractive
########################################################################################
FROM xilinx_install_depends_petalinux_v2018.3 AS xilinx_install_petalinux_v2018.3
LABEL author="Jason Moss"

# Re-use previous stage ARG
ARG USER_ACCT
ARG HOME_DIR

# Switch to the user account
USER $USER_ACCT

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_INSTALL_LOCATION
ARG XLNX_DOWNLOAD_LOCATION
ARG INSTALL_SERVER_URL
ARG XLNX_MALI_BINARY

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Get the MALI userspace binaries
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& mkdir -p $XLNX_DOWNLOAD_LOCATION/tmp \
	&& cd $XLNX_DOWNLOAD_LOCATION/tmp \
	&& mkdir -p "${XLNX_MALI_BINARY%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$XLNX_MALI_BINARY -O $XLNX_MALI_BINARY \
	&& tar xf $XLNX_MALI_BINARY mali/rel-v2018.3/downloads-mali.tar \
	&& tar xf mali/rel-v2018.3/downloads-mali.tar \
	&& mv $XLNX_DOWNLOAD_LOCATION/tmp/downloads-mali/* $XLNX_DOWNLOAD_LOCATION/"${XLNX_MALI_BINARY%/*}" \
	&& rm -rf $XLNX_DOWNLOAD_LOCATION/tmp

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_PETALINUX_INSTALLER
ARG XLNX_PETALINUX_AUTOINSTALL_SCRIPT
ARG XLNX_PETALINUX_INSTALL_DIR

# Get the Petalinux installer
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
	&& mkdir -p "${XLNX_PETALINUX_INSTALLER%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$XLNX_PETALINUX_INSTALLER -O $XLNX_PETALINUX_INSTALLER \
# Get the auto install script \
	&& wget -nv $INSTALL_SERVER_URL/$XLNX_PETALINUX_AUTOINSTALL_SCRIPT \
# Remove windows line termination (this was added for powershell-based builds) \
	&& dos2unix -ascii -q $XLNX_PETALINUX_AUTOINSTALL_SCRIPT \
# Have new user shell start in yocto folder \
	&& echo "cd $XLNX_PETALINUX_INSTALL_DIR" >> $HOME_DIR/.bashrc \
# Setup the User Locale \
# Yocto requires a 'UTF-8' locale \
# Xilinx tools specifically require the 'en_US.UTF-8' locale \
	&& echo "export LANG=en_US.UTF-8" >> $HOME_DIR/.bashrc \
	&& export "LANG=en_US.UTF-8" \
# Setup installer permissions \
	&& chmod a+x $XLNX_PETALINUX_INSTALLER \
	&& chmod a+x $XLNX_PETALINUX_AUTOINSTALL_SCRIPT

# Arguments can be filled at build time using the '--build-arg' option
ARG KEYBOARD_CONFIG_FILE
ARG XTERM_CONFIG_FILE

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
	&& cp $XTERM_CONFIG_FILE $HOME_DIR

# Execute installer expect script to install Petalinux Tools
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
	&& cat ./$XLNX_PETALINUX_AUTOINSTALL_SCRIPT \
	&& export TERM=xterm \
	&& ./$XLNX_PETALINUX_AUTOINSTALL_SCRIPT $XLNX_PETALINUX_INSTALLER $XLNX_PETALINUX_INSTALL_DIR \
# Setup bashrc to source petalinux settings on login \
	&& echo ". $XLNX_PETALINUX_INSTALL_DIR/settings.sh" >> $HOME_DIR/.bashrc \
# Source the petalinux setup script \
	&& . $XLNX_PETALINUX_INSTALL_DIR/settings.sh \
# Turn off webtalk reporting \
	&& petalinux-util --webtalk off \
# Cleanup temporary install files \
	&& rm -rf $XLNX_INSTALL_LOCATION/tmp

# Cleanup apt cache and temporary files to reduce image size
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections

