# Dockerfile.yocto_v2018.3
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
# - Xilinx XSDK Tools v2018.3 (Xilinx SDK v2018.3 release)
#
#
# Multi-stage build organization:
# -------------------------------
# 1. base_os_xsdk_v2018.3							: Base Ubuntu 16.04.3 image with a few basics, locale setup and user account
# 2. |___ xilinx_install_depends_xsdk_v2018.3		: Xilinx specific install dependencies
# 3.      |___ xilinx_install_xsdk_v2018.3			: +Xilinx ARM Mali GPU binaries, XSDK XSDK tool installation
########################################################################################
# Base OS Image:
# --------------
#	- Ubuntu 16.04.3
#		- start with the base Ubuntu 16.04.3 build from Ubuntu release tarballs
########################################################################################
FROM ubuntu:16.04.3 AS base_os_xsdk_v2018.3
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
# Xilinx SDK v2018.3 Dependencies:
# ---------------------------
#	- Yocto Rocko v2.4.1 / Xilinx Repo Manifests v2018.3
#		- Rocko Release Documentation: 
#			- https://www.yoctoproject.org/docs/2.4.1/ref-manual/ref-manual.html
#			- https://lists.yoctoproject.org/pipermail/yocto-announce/2018-January/000128.html
#		- Xilinx Repo Manifests: https://github.com/Xilinx/yocto-manifests/tree/rel-v2018.3
#		- Meta-Xilinx-Tools Layer: http://www.wiki.xilinx.com/Using+meta-xilix-tools+layer
#		- Repo tool documentation: https://source.android.com/setup/develop/repo
########################################################################################
FROM base_os_xsdk_v2018.3 AS xilinx_install_depends_xsdk_v2018.3
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
# add i386 architecture for zlib1g-dev dependency \
	&& sudo dpkg --add-architecture i386 \
	&& sudo apt-get update \
	&& sudo apt-get install -y \
# petalinux base dependencies \
#	&& sudo apt-get install -y \
#		tofrodos \
#		iproute2 \
#		gawk \
#		xvfb \
		git \
		make \
#		net-tools \
#		libncurses5-dev \
# Install update-inetd for tftpd \
	    update-inetd \
		tftpd \
#		zlib1g-dev:i386 \
#		libssl-dev \
#		flex \
#		bison \
#		libselinux1 \
#		gnupg \
		wget \
#		diffstat \
#		chrpath \
#		socat \
		xterm \
		autoconf \
#		libtool-bin \
# Optional use of BSDTAR vs. TAR if there are issues in docker container due to GO \
		tar \
#		bsdtar \
		unzip \
#		texinfo \
#		zlib1g-dev \
		gcc-multilib \
		build-essential \
		libsdl1.2-dev \
		libglib2.0-dev \
		screen \
#		pax \
		gzip \
# python3-gi is used by bitbake's dependency explorer \
#		python3-gi \
# undocumented dependencies \
		less \
		lsb-release \
#		fakeroot \
# yocto depedencies (for petalinux) \
#		cpio \
#		rsync \
		xorg \
# dependency for autoinstall of petalinux \
#		expect \
# used to strip windows line terminations from autoinstall scripts in powershell \
		dos2unix \
# Install remaining dependencies for Vivado \
	&& sudo apt-get install -y \
# additional Vivado dependencies \
# derived from the perl 'ldd-recursive.pl' script \
#	 	libboost-signals-dev \
#	 	google-perftools \
# JRE for Eclipse to use the Xilinx SDK \
		default-jre
# The following PPA is only required if using Ubuntu 16.04.4 base images to update to newer GCCXX libs
# # Get the add-apt-repository command \
# 		software-properties-common \
# # Add the Ubuntu test PPA to access libstdc++6:GCLIBXX 3.4.22 support in Ubuntu 16.04.4 \
# 	&& sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y \
# 	&& sudo apt-get update \
# # Install the latest libstdc++6 \
# 	&& sudo apt-get install -y \
# 		libstdc++6

# Arguments can be filled at build time using the '--build-arg' option
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
#	- Xilinx SDK v2018.3
#		- Download Link: 
#			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2018.3_0614_1954_Lin64.bin
#		- Release Notes;
#			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2017-4.html
#		- Run the web installer batch mode configuration generator to create a batch mode configuration file (for headless install)
#			- ./xsetup -b ConfigGen
#		- Run the web installer with the batch mode configuration generated to download either the XSCT only or FULL image 
#			- Download full image (Install Separately)
#				- Location: Same location as this dockerfile
#			- Download files to create full image for selected platform(s)
#				- Linux
#			- Create Archive for the downloaded image
#				- None
#		- After the download is complete, create an archive with the downloaded content:
#			- $ tar -zcvf Xilinx_SDK_2018.3_0614_1954_Lin64.tar.gz ./
#
#	- Xilinx ARM MALI GPU Binaries
#		- Download Link:
#			- https://www.xilinx.com/publications/products/tools/mali-400-userspace.tar
#		- Release Notes:
#			- http://www.wiki.xilinx.com/Adding+MALI+userspace+binaries+in+Yocto+builds
#			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
#
#	- Keyboard Configuration
#		- Xilinx Installer is X11-based and requires a valid keyboard configuration
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
FROM xilinx_install_depends_xsdk_v2018.3 AS xilinx_install_xsdk_v2018.3
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

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_XSDK_OFFLINE_INSTALLER
ARG XLNX_XSDK_BATCH_CONFIG_FILE

# Get the SDK Offline installer
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
 	&& cd $XLNX_INSTALL_LOCATION/tmp \
# Get Xilinx SDK Batch Mode configuration file \
 	&& mkdir -p "${XLNX_XSDK_BATCH_CONFIG_FILE%/*}" \
 	&& wget -nv $INSTALL_SERVER_URL/$XLNX_XSDK_BATCH_CONFIG_FILE -O $XLNX_XSDK_BATCH_CONFIG_FILE \
 	&& cat $XLNX_XSDK_BATCH_CONFIG_FILE \
# Get Xilinx SDK Offline Installer \
 	&& mkdir -p "${XLNX_XSDK_OFFLINE_INSTALLER%/*}" \
 	&& wget -nv --no-cache $INSTALL_SERVER_URL/$XLNX_XSDK_OFFLINE_INSTALLER -O $XLNX_XSDK_OFFLINE_INSTALLER \
	&& chmod a+x $XLNX_XSDK_OFFLINE_INSTALLER \
# Decompress XSDK Installer \
 	&& tar -zxf $XLNX_XSDK_OFFLINE_INSTALLER && ls -al \
# Have new user shell start in yocto folder \
	&& echo "cd $XLNX_INSTALL_LOCATION" >> $HOME_DIR/.bashrc \
# Setup the User Locale \
# Xilinx tools specifically require the 'en_US.UTF-8' locale \
	&& echo "export LANG=en_US.UTF-8" >> $HOME_DIR/.bashrc \
	&& export "LANG=en_US.UTF-8" \
# Setup bashrc to source petalinux settings on login \
	&& echo ". $XLNX_INSTALL_LOCATION/SDK/2018.3/settings64.sh" >> $HOME_DIR/.bashrc \
# Setup LD_LIBRARY_PATH to include Vivado included Linux libraries \
#	&& echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XLNX_INSTALL_LOCATION/SDK/2018.3/lib/lnx64.o/" >> $HOME_DIR/.bashrc \
# Setup installer permissions \
  	&& chmod a+x xsetup \
# Run Setup in batch mode to install XSCT Tools only from the XSDK \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
	&& ./xsetup \
  		--agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  		--config $XLNX_XSDK_BATCH_CONFIG_FILE \
  		--batch INSTALL \
# Cleanup Temporary Files \
  	&& cd $HOME_DIR \
  	&& rm -rf $XLNX_INSTALL_LOCATION/tmp

# Clean up apt cache and temporary files to reduce image size
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Restore Debconf interactive mode for final image \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
