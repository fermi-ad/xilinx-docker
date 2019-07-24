# Dockerfile
########################################################################################
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 7/24/2019
# 
# What's installed in the image created by this docker file?
# ----------------------------------------------------------
# - Ubuntu 18.04.1 x64 base OS image
# - Xilinx Yocto Thud (v2.6.1) (Xilinx Petalinux v2019.1 release)
# - Xilinx SDK XSCT Tools are no longer installed in the container, a binary release is provided as part of meta-xilinx-tools layer
#
#
# Multi-stage build organization:
# -------------------------------
# 1. base_os_yocto_v2019.1							: Base Ubuntu 18.04.1 image with a few basics, locale setup and user account
# 2. |___ xilinx_install_depends_yocto_v2019.1		: +Yocto Rocko depedencies, Baseline v2019.1 Xilinx Yocto Manifest, +Xilinx specific install dependencies
# 3.      |___ xilinx_install_yocto_v2019.1			: +Xilinx ARM Mali GPU binaries, XSDK SCT tool installation
########################################################################################
# Base OS Image:
# --------------
#	- Ubuntu 18.04.1
#		- start with the base Ubuntu 18.04.1 build from Ubuntu release tarballs
########################################################################################
FROM ubuntu:18.04.1 AS base_os_yocto_v2019.1
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
# Yocto v2019.1 Dependencies:
# ---------------------------
#	- Yocto Thud v2.6.1 / Xilinx Repo Manifests v2019.1
#		- Rocko Release Documentation: 
#			- https://www.yoctoproject.org/docs/2.6.1/ref-manual/ref-manual.html
#			- https://lists.yoctoproject.org/pipermail/yocto-announce/2019-February/000152.html
#		- Xilinx Repo Manifests: https://github.com/Xilinx/yocto-manifests/tree/rel-v2019.1
#		- Meta-Xilinx-Tools Layer: http://www.wiki.xilinx.com/Using+meta-xilix-tools+layer
#		- Repo tool documentation: https://source.android.com/setup/develop/repo
########################################################################################
FROM base_os_yocto_v2019.1 AS xilinx_install_depends_yocto_v2019.1
LABEL author="Jason Moss"

# Re-use previous stage ARG
ARG USER_ACCT
ARG HOME_DIR

# Switch to the user account
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_INSTALL_LOCATION

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Setup install location folder permissions
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
	&& sudo apt-get update \
	&& sudo apt-get install -y \
# Install Yocto Essential dependencies (see ref-manual.html linked above)
		gawk \
		wget \
		git-core \
		diffstat \
		unzip \
		texinfo \
		gcc-multilib \
		build-essential \
		chrpath \
		socat \
		cpio \
		python \
		python3 \
		python3-pip \
		python3-pexpect \
		xz-utils \
		debianutils \
		iputils-ping \
# Install Yocto Graphical and Eclipse Plug-In Extra dependencies \
		libsdl1.2-dev \
		xterm \
# Install Yocto Documentation dependencies \
		make \
		xsltproc \
		docbook-utils \
		fop \
		dblatex \
		xmlto \
# Install Yocto OE Self Test dependencies \
		python-git \
# python3-gi is used by bitbake's dependency explorer \
		python3-gi \
# Install CURL (needed for REPO command) \
		curl \
# Install the REPO command \
	&& sudo bash -c "curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo" \
	&& sudo chmod a+x /usr/local/bin/repo \
# Install Xorg and file, which are required by the Xilinx SDK installer setup
	&& sudo apt-get install -y \
		file \
		xorg \
# Install extra packages that will be used in the container for development \
		xterm \
		less \
		lsb-release \
# used to strip windows line terminations from files \
		dos2unix

# Arguments can be filled at build time using the '--build-arg' option
ARG YOCTO_DIR
ARG YOCTO_VER
ARG YOCTO_MANIFEST_URL
ARG YOCTO_MANIFEST_BRANCH
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Setup GIT with a dummy username and email address
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& git config \
		--global user.name $GIT_USER_NAME \
	&& git config \
		--global user.email $GIT_USER_EMAIL \
	&& git config \
		--global color.ui true \
# Initialize Yocto using the release manifest from Xilinx \f
# Create a working branch of all yocto projects locally \
	&& mkdir -p $YOCTO_DIR \
	&& cd $YOCTO_DIR \
	&& repo init -u $YOCTO_MANIFEST_URL -b $YOCTO_MANIFEST_BRANCH \
	&& repo sync && repo start $YOCTO_VER"_working" --all

########################################################################################
#	- Xilinx SDK v2019.1
#		- Note: Xilinx SDK Web Installer is no longer needed
# 		- See the meta-xilinx-tools layer documentation for more information
# 		- https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841671/Using+meta-xilinx-tools+layer
#
#	- Xilinx ARM MALI GPU Binaries
#		- Download Link:
#			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
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
FROM xilinx_install_depends_yocto_v2019.1 AS xilinx_install_yocto_v2019.1
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
ARG XLNX_MALI_BINARY

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Get the MALI userspace binaries
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& mkdir -p $XLNX_DOWNLOAD_LOCATION/tmp \
	&& cd $XLNX_DOWNLOAD_LOCATION/tmp \
	&& mkdir -p "${XLNX_MALI_BINARY%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$XLNX_MALI_BINARY -O $XLNX_MALI_BINARY \
	&& tar xf $XLNX_MALI_BINARY mali/rel-v2019.1/downloads-mali.tar \
	&& tar xf mali/rel-v2019.1/downloads-mali.tar \
	&& mv $XLNX_DOWNLOAD_LOCATION/tmp/downloads-mali/* $XLNX_DOWNLOAD_LOCATION \
	&& rm -rf $XLNX_DOWNLOAD_LOCATION/tmp

# Arguments can be filled at build time using the '--build-arg' option
ARG YOCTO_DIR

# Get the SDK Offline installer
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& echo "cd $YOCTO_DIR" >> $HOME_DIR/.bashrc \
# Setup the User Locale \
# Xilinx tools specifically require the 'en_US.UTF-8' locale \
	&& echo "export LANG=en_US.UTF-8" >> $HOME_DIR/.bashrc \
	&& export "LANG=en_US.UTF-8"

# Arguments can be filled at build time using the '--build-arg' option
ARG KEYBOARD_CONFIG_FILE
ARG XTERM_CONFIG_FILE

# Configure the Keyboard and Xterm (needed for SDK)
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

# Clean up apt cache and temporary files to reduce image size
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Restore Debconf interactive mode for final image \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
