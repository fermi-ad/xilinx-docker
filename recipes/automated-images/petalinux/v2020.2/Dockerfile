# Dockerfile
########################################################################################
# Maintainer:
#	- Jason Moss
#
# Created: 
#	- 12/14/2020
########################################################################################
FROM xilinx-ubuntu-18.04.2-user:v2020.2 AS xilinx_install_petalinux_v2020.2
LABEL author="Jason Moss"

# Arguments can be filled at build time using the '--build-arg' option
ARG USER_ACCT
ARG HOME_DIR
ARG XLNX_INSTALL_LOCATION
ARG DOCKER_BUILD_INCLUDE_XLNX_MALI
ARG INSTALL_SERVER_URL

# Turn on shell command expansion inside docker container IF Debug is configured
ARG BUILD_DEBUG

# Arguments can be filled at build time using the '--build-arg' option
ARG XLNX_MALI_BINARY
ARG XLNX_PETALINUX_INSTALLER
ARG XLNX_PETALINUX_AUTOINSTALL_SCRIPT
ARG XLNX_PETALINUX_INSTALL_DIR

# Switch to the user account
USER $USER_ACCT
ENV DEBIAN_FRONTEND=noninteractive

# Get the MALI userspace binaries
RUN if [ $BUILD_DEBUG -ne 0 ]; then set -x; fi \
	&& sudo mkdir -p $XLNX_INSTALL_LOCATION/tmp \
	&& sudo chown -R $USER_ACCT:$USER_ACCT $XLNX_INSTALL_LOCATION \
# Include the ARM MALI pre-builts if the configuration is set \
	&& if [[ $DOCKER_BUILD_INCLUDE_XLNX_MALI -ne 0 ]]; then \
		mkdir -p $XLNX_INSTALL_LOCATION/downloads/tmp \
		&& cd $XLNX_INSTALL_LOCATION/downloads/tmp \
		&& mkdir -p "${XLNX_MALI_BINARY%/*}" \
		&& wget -nv $INSTALL_SERVER_URL/$XLNX_MALI_BINARY -O $XLNX_MALI_BINARY \
		&& tar xf $XLNX_MALI_BINARY mali/rel-v2020.1/downloads-mali.tar \
		&& tar xf mali/rel-v2020.1/downloads-mali.tar \
		&& mv $XLNX_INSTALL_LOCATION/downloads/tmp/downloads-mali/* $XLNX_INSTALL_LOCATION/downloads \
		&& rm -rf $XLNX_INSTALL_LOCATION/downloads/tmp; \
	fi \
# Get the Petalinux installer \
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
	&& chmod a+x $XLNX_PETALINUX_AUTOINSTALL_SCRIPT	\
# Execute installer expect script to install Petalinux Tools \
	&& cd $XLNX_INSTALL_LOCATION/tmp \
	&& cat ./$XLNX_PETALINUX_AUTOINSTALL_SCRIPT \
	&& export TERM=xterm \
	&& mkdir -p $XLNX_PETALINUX_INSTALL_DIR \
	&& ./$XLNX_PETALINUX_AUTOINSTALL_SCRIPT $XLNX_PETALINUX_INSTALLER "$XLNX_PETALINUX_INSTALL_DIR" \
# Setup bashrc to source petalinux settings on login \
	&& echo ". $XLNX_PETALINUX_INSTALL_DIR/settings.sh" >> $HOME_DIR/.bashrc \
# Source the petalinux setup script \
	&& . $XLNX_PETALINUX_INSTALL_DIR/settings.sh \
# Turn off webtalk reporting \
	&& petalinux-util --webtalk off \
# Cleanup Temporary Files \
	&& rm -rf $XLNX_INSTALL_LOCATION/tmp \
# Cleanup apt cache and temporary files to reduce image size \
	&& sudo apt-get clean \
	&& sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& sudo echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
