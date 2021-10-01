# Dockerfile
########################################################################################
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 11/23/2020
########################################################################################
FROM xilinx-ubuntu-18.04.2-user:v2019.2 AS xilinx_install_vitis_v2019.2
LABEL author="Jason Moss"

# Arguments can be filled at build time using the '--build-arg' option
ARG USER_ACCT
ARG HOME_DIR
ARG XLNX_INSTALL_LOCATION
ARG XLNX_DOWNLOAD_LOCATION
ARG INSTALL_SERVER_URL

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_UNIFIED_OFFLINE_INSTALLER
ARG XLNX_UNIFIED_BATCH_CONFIG_FILE
ARG XLNX_UNIFIED_INSTALLER_BASENAME
#ARG XLNX_XRT_DEPENDENCY_SCRIPT_URL
#ARG XLNX_XRT_DEPENDENCY_SCRIPT
ARG HOST_KERNEL_HEADER_ARCHIVE
ARG XLNX_XRT_PREBUILT_INSTALLER

# Switch to the user account
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& sudo chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
 	&& cd $XLNX_INSTALL_LOCATION/tmp \
# Note: This section executing the XRT dependency install script is disabled \
# XRT dependencies are manually installed later due to potential mismatch between \
# Host and Container Kernel header versions \
# To work around this, host headers are provided to the container during the build process \
# Get the XRT dependency script \
# 	&& mkdir -p "${XLNX_XRT_DEPENDENCY_SCRIPT%/*}" \
#	&& wget -nv --no-cache $XLNX_XRT_DEPENDENCY_SCRIPT_URL -O $XLNX_XRT_DEPENDENCY_SCRIPT \
#	&& ls -al $XLNR_XRT_DEPENDENCY_SCRIPT \
#	&& chmod a+x $XLNX_XRT_DEPENDENCY_SCRIPT \
# Update apt package cache \
#	&& sudo apt-get update \
# Install XRT Dependencies \
#	&& $XLNX_XRT_DEPENDENCY_SCRIPT \
# Install XRT Dependencies manually \
	&& sudo apt-get update \
	&& sudo apt-get install -y \
	 cmake \
     cppcheck \
     curl \
     dkms \
     g++ \
     gcc \
     gdb \
     git \
     gnuplot \
     libboost-dev \
     libboost-filesystem-dev \
     libboost-program-options-dev \
     libdrm-dev \
     libjpeg-dev \
     libjson-glib-dev \
     libgtest-dev \
     libncurses5-dev \
     libopencv-core-dev \
     libpng-dev \
     libprotoc-dev \
     libssl-dev \
     libtiff5-dev \
     libxml2-dev \
     libyaml-dev \
     linux-libc-dev \
     lm-sensors \
     lsb-release \
     make \
     ocl-icd-dev \
     ocl-icd-libopencl1 \
     opencl-headers \
     ocl-icd-opencl-dev \
     perl \
     python \
     python-pip \
     pciutils \
     pkg-config \
     protobuf-compiler \
     python3-sphinx \
     python3-sphinx-rtd-theme \
     sphinx-common \
     strace \
     unzip \
     uuid-dev \
     libcurl4-openssl-dev \
     libssl-dev \
     libudev-dev \
     libsystemd-dev \
# Get the Kernel Header Source Bundle from the Host Machine \
	&& mkdir -p "${HOST_KERNEL_HEADER_ARCHIVE%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$HOST_KERNEL_HEADER_ARCHIVE -O $HOST_KERNEL_HEADER_ARCHIVE \
# Decompress the header source into the container \
	&& sudo tar -zxvf $HOST_KERNEL_HEADER_ARCHIVE -C / \
# Get the XRT Installer \
 	&& mkdir -p "${XLNX_XRT_PREBUILT_INSTALLER%/*}" \
	&& wget -nv $INSTALL_SERVER_URL/$XLNX_XRT_PREBUILT_INSTALLER -O $XLNX_XRT_PREBUILT_INSTALLER \
# Install XRT \
# Note: Installation will fail to build DKMS kernel modules AND will fail installing PYOPENCL \
# This is EXPECTED - we don't need XRT fully functional in this docker container, because it will not be used \
# with Alveo cards - we just need XRT installed in /opt/xilinx/xrt so the tools can be used during Vitis-AI build flows
# in v2019.2 projects \
	&& sudo dpkg -i $XLNX_XRT_PREBUILT_INSTALLER \
# Get the Unified installer \
# RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
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
	&& echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XLNX_INSTALL_LOCATION/Vitis/2019.2/lib/lnx64.o/" >> $HOME_DIR/.bashrc \
# Setup installer permissions \
	&& cd $XLNX_UNIFIED_INSTALLER_BASENAME \
  	&& chmod a+x xsetup \
	&& sudo apt-get install -y \
# undocumented vitis post install dependencies \
		xz-utils \
# Run Setup in batch mode to install Unified \
	&& ./xsetup \
  		--agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  		--config ../$XLNX_UNIFIED_BATCH_CONFIG_FILE \
  		--batch INSTALL \
# Cleanup Temporary Files \
  	&& cd $HOME_DIR \
  	&& rm -rf $XLNX_INSTALL_LOCATION/tmp \
# Cleanup apt cache and temporary files to reduce image size \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
