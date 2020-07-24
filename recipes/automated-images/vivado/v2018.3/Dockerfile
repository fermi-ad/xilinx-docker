# Dockerfile
########################################################################################
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 7/24/2020
#
# What's installed in the image created by this docker file?
# ----------------------------------------------------------
# - Ubuntu 16.04.4 x64 base OS image
# - Xilinx Vivado v2018.3 (Xilinx Vivado v2018.3 release)
#
#
# Single-stage optimized build organization:
# ------------------------------------------
# 1. xilinx-ubuntu-16.04.4-user:v2018.3				: Base Ubuntu 16.04.4 image with a few basics, locale setup and user account
# 2. |___ xilinx_install_vivado_v2018.3				: +Xilinx Tool Installation
########################################################################################
FROM xilinx-ubuntu-16.04.4-user:v2018.3 AS xilinx_install_vivado_v2018.3
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
ARG XLNX_VIVADO_BATCH_CONFIG_FILE
ARG XLNX_VIVADO_OFFLINE_INSTALLER

# Switch to the user account
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

# Get the Unified installer
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& sudo chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
 	&& cd $XLNX_INSTALL_LOCATION/tmp \
# Get Xilinx Unified Installer Batch Mode configuration file \
 	&& mkdir -p "${XLNX_VIVADO_BATCH_CONFIG_FILE%/*}" \
 	&& wget -nv $INSTALL_SERVER_URL/$XLNX_VIVADO_BATCH_CONFIG_FILE -O $XLNX_VIVADO_BATCH_CONFIG_FILE \
 	&& cat $XLNX_VIVADO_BATCH_CONFIG_FILE \
# Get Xilinx Unified Installer Offline Installer \
 	&& mkdir -p "${XLNX_VIVADO_OFFLINE_INSTALLER%/*}" \
 	&& wget -nv --no-cache $INSTALL_SERVER_URL/$XLNX_VIVADO_OFFLINE_INSTALLER -O $XLNX_VIVADO_OFFLINE_INSTALLER \
	&& chmod a+x $XLNX_VIVADO_OFFLINE_INSTALLER \
# Decompress Unified Installer \
 	&& tar -zxf $XLNX_VIVADO_OFFLINE_INSTALLER && ls -al \
# Have new user shell start in Xilinx tool folder \
	&& echo "cd $XLNX_INSTALL_LOCATION" >> $HOME_DIR/.bashrc \
# Setup the User Locale \
# Xilinx tools specifically require the 'en_US.UTF-8' locale \
	&& echo "export LANG=en_US.UTF-8" >> $HOME_DIR/.bashrc \
	&& export "LANG=en_US.UTF-8" \
# Setup bashrc to source petalinux settings on login \
	&& echo ". $XLNX_INSTALL_LOCATION/Vivado/2018.3/settings64.sh" >> $HOME_DIR/.bashrc \
# Setup LD_LIBRARY_PATH to include Unified included Linux libraries \
	&& echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$XLNX_INSTALL_LOCATION/Vivado/2018.3/lib/lnx64.o/" >> $HOME_DIR/.bashrc \
# Setup installer permissions \
  	&& chmod a+x xsetup \
	&& sudo apt-get install -y \
# undocumented vitis post install dependencies \
		xz-utils \
# Run Setup in batch mode to install Unified \
	&& ./xsetup \
  		--agree XilinxEULA,3rdPartyEULA,WebTalkTerms \
  		--config $XLNX_VIVADO_BATCH_CONFIG_FILE \
  		--batch INSTALL \
# Cleanup Temporary Files \
  	&& cd $HOME_DIR \
  	&& rm -rf $XLNX_INSTALL_LOCATION/tmp \
# Cleanup apt cache and temporary files to reduce image size \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
