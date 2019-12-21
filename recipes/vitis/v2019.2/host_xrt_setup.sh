#!/bin/bash
########################################################################################
# Host Dependency Install Script
# - XRT Requires specific host dependencies
#
# Maintainer:
#	- Jason Moss (jason.moss@avnet.com)
#	- Xilinx Applications Engineer, Embedded Software
#
# Created: 
#	- 12/17/2019
#
# Source configuration information for a v2019.2 Unified Image build
source include/configuration.sh

# Turn on debug output if set
if [ $BUILD_DEBUG -ne 0 ]; then 
	set -x;
fi

# Check for Xilinx XRT Installer
if [ -f $XLNX_XRT_PREBUILT_INSTALLER ] || [ -L $XLNX_XRT_PREBUILT_INSTALLER ]; then
	# File exists and is not a link
	echo "Xilinx XRT Prebuilt Installer: [Good] "$XLNX_XRT_PREBUILT_INSTALLER
else
	# File does not exist
	echo "ERROR: Xilinx XRT Prebuilt Installer: [Missing] "$XLNX_XRT_PREBUILT_INSTALLER
	exit $EX_OSFILE
fi

# Get the XRT dependency script
wget -nv $XLNX_XRT_DEPENDENCY_SCRIPT -O $INSTALL_DEPENDS_DIR/xrtdeps.sh
chmod a+x $INSTALL_DEPENDS_DIR/xrtdeps.sh

# Execute to install dependencies
/bin/bash $INSTALL_DEPENDS_DIR/xrtdeps.sh

# Install Python Setuptools
#sudo apt-get install -y python-setuptools

# Upgrade PIP to prep for XRT install
# See AR #73055 (https://www.xilinx.com/support/answers/73055.html) \
sudo apt remove -y python-pyopencl
sudo pip install --upgrade pip
sudo python -m pip install --upgrade setuptools
sudo python -m pip install --upgrade pyopencl
sudo python -m pip install --upgrade numpy
sudo apt install ./$XLNX_XRT_PREBUILT_INSTALLER

# Clone the XRT Repository locally for easy access
git clone $XLNX_XRT_GIT_REPO $INSTAL_DEPENDS_DIR/xrt_source/

