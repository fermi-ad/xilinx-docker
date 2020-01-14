#!/bin/bash
########################################################################################
# Host Dependency Uninstall Script
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

# Upgrade PIP to prep for XRT install
# See AR #73055 (https://www.xilinx.com/support/answers/73055.html) \
sudo apt remove -y python-pyopencl
sudo python -m pip uninstall setuptools -y
sudo python -m pip uninstall pyopencl -y  
sudo python -m pip uninstall numpy -y
sudo apt remove xrt 

# Clone the XRT Repository locally for easy access
git rm -rf $INSTALL_DEPENDS_DIR/xrt_source/

