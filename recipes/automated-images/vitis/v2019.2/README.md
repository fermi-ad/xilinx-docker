[//]: # (README.md - Vitis v2019.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> Dockerfile.base.generate_configs
-> Dockerfile.iso.generate_configs
-> generate_configs.sh
-> configs/
	-> xlnx_unified_vitis.config
-> depends/
	-> Xilinx_Unified_2019.2_1106_2127_Lin64.bin
	-> Xilinx_Vitis_2019.2_1106_2127.tar.gz
-> include/
	-> configuration.sh
```
# Setup Host System for XRT
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf
```bash
$ wget -nv https://raw.githubusercontent.com/Xilinx/XRT/2019.2/src/runtime_src/tools/scripts/xrtdeps.sh -O depends/xrtdeps.sh
```

# Need to determine XRT dependencies?
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Unified Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Vitis_2019.2_1106_2127.tar.gz
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2019.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk300137739.html

## Download Xilinx Unified All OS Single-File Download Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef-vitis.html?filename=Xilinx_Vitis_2019.2_1106_2127.tar.gz
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2019.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk300137739.html

## Generate Vitis Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2019.2_1106_2127_Lin64.bin depends/
$ ln -s <path-to-offline-installer>/Xilinx_Vitis_2019.2_1106_2127.tar.gz depends/
```

## Download the Xilinx Runtime (XRT)
- The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
	- Pre-built XRT Ubuntu 18.04 Package for v2019.2
		- Installation Instructions:
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#pjr1542153622642
		- Download Link:
			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_18.04-xrt.deb

### Reference - Building XRT from Source
- XRT can be built form source as an option
	- Instructions v2019.2:
		- https://xilinx.github.io/XRT/2019.2/html/index.html

## Download the Alveo Data Center Accelerator Card Target Platforms (optional)
- Alveo Datacenter accelerator cards have pre-built packages available:
	- Pre-built Alveo Data Center Accelerator Card Packages
		- Installation Instructions
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#uxq1573167801088
		- Download Links:
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/device-models.html
				- Alveo Accelerator Card Downloads (drop-down menu)

## Download the Embedded Platform Targets (optional)
- Embedded Development platforms have pre-built packages available.
	- Pre-built Embedded Edge Platform packages
		- Installation Instructions: 
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#rvu1542160683426
		- Download Links: 
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/edge-platforms.html

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 18.04.2 image (one time)
```bash
$ pushd ../../base-images/ubuntu-18.04.2/
$ sudo ./build_image.sh --iso
$ popd
```

## Generate an Ubuntu 18.04.2 user image 
- This contains all the dependencies for the v2020.1 Xilinx Tools

```bash
bash:
$ pushd ../../user-images/v2020.1/ubuntu-18.04.2-user
$ ./build_image.sh --iso
$ popd
```

## Generate Vitis Image Install Configuration Files (one time)

Note: in v2019.2, disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the dependency generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx Unified batch mode configuration (generate)
	- Select Vitis Unified Software Platform: option ```1```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```Modules=...DocNav:0,...``` 
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=1```
		- ```EnableDiskUsageOptimization=1```
	- Save with ```:wq```

- Review the generated configurations

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1940 Jul 17 07:49 _generated/configs/xlnx_unified_vitis.config
-----------------------------------

```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Build a v2019.2 Vitis Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	xilinx-vitis        v2019.2             f035639c5d12        19 seconds ago      55.5GB
	-----------------------------------
	Image Build Complete...
	STARTED :Mon 23 Nov 2020 02:54:01 PM EST
	ENDED   :Mon 23 Nov 2020 04:28:13 PM EST
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vitis_v2019.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vitis_v2019-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vitis:v2019.2 \
	/bin/bash
a1c16b9028644bd556e1c6701f75eb4991c343e04b017fbd93d9976a43d8b165
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS               NAMES
a1c16b902864        xilinx-vitis:v2019.2   "/bin/bash"         19 seconds ago      Up 17 seconds                           xilinx_vitis_v2019.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vitis_v2019.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
xilinx@xilinx_vitis_v2019-2:/$
```

## Execute Vitis Tools
- Launch Vitis from the working container
```bash
xterm:
xilinx@xilinx_vitis_v2019-2:/opt/Xilinx$ vitis

****** Xilinx Vitis Development Environment
****** Vitis v2019.2 (64-bit)
  **** SW Build 2700185 on Thu Oct 24 18:46:26 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

Launching Vitis with command /opt/Xilinx/Vitis/2019.2/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false -Dosgi.configuration.area=@user.home/.Xilinx/Vitis/2019.2 --add-modules=ALL-SYSTEM --add-modules=jdk.incubator.httpclient --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.desktop/sun.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing.tree=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.synth=ALL-UNNAMED --add-opens=java.desktop/com.sun.awt=ALL-UNNAMED --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED &
xilinx@xilinx_vitis_v2019-2:/opt/Xilinx$
```
