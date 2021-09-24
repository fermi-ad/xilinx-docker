[//]: # (README.md - Vitis v2020.2 Build Environment)

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
	-> Xilinx_Unified_2020.2_1118_1232_Lin64.bin
	-> Xilinx_Unified_2020.2_1118_1232.tar.gz
-> include/
	-> configuration.sh
```

# Setup Host System for XRT
## Download xrtdeps.sh shell script
- Package configurations are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf
```bash
$ wget -nv https://raw.githubusercontent.com/Xilinx/XRT/2020.1/src/runtime_src/tools/scripts/xrtdeps.sh -O depends/xrtdeps.sh
```

# Need to determine XRT configurations?
## Download xrtdeps.sh shell script
- Package configurations are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/html_docs/accelerator_cards/alveo_doc_280/dwt1537506874594.html

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2020.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.2_1118_1232_Lin64.bin
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_2/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_2/vitis_doc/wlk1553469789555.html

## Download Xilinx Unified All OS Single-File Download Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2020.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.2_1118_1232.tar.gz
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_2/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/wlk1553469789555.html

## Generate Vitis Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2020.2_1118_1232_Lin64.tar.gz depends/
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2020.2_1118_1232_Lin64.bin depends/
```

<--- Needs Updated --->
## Download the Xilinx Runtime (XRT)
- The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
	- Pre-built XRT Ubuntu 18.04 Package for v2020.1
		- Installation Instructions:
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug1451-xrt-release-notes.pdf
		- Download Link:
			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_18.04-amd64-xrt.deb
<--- Needs Updated --->

### Reference - Building XRT from Source
- XRT can be built form source as an option
	- Instructions v2020.2:
		- https://xilinx.github.io/XRT/2020.2/html/index.html

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 20.04.1 image (one time)
```bash
$ pushd ../../base-images/ubuntu-20.04.1/
$ sudo ./build_image.sh --iso
$ popd
```

## Generate an Ubuntu 20.04.1 user image 
- This contains all the dependencies for the v2020.2 Xilinx Tools
- Note: Petalinux v2020.2 requires Ubuntu 18.04 or 16.04 due to glibc compatibility

```bash
bash:
$ pushd ../../user-images/v2020.2/ubuntu-20.04.1-user
$ ./build_image.sh --iso
$ popd
```

## Generate Vitis Image Install Configuration Files (one time)

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh --iso
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
-rw-r--r-- 1 xilinx xilinx 1837 Jan 15 22:55 _generated/configs/xlnx_unified_vitis.config
-----------------------------------

```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Build a v2020.2 Vitis Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY     TAG       IMAGE ID       CREATED              SIZE
	xilinx-vitis   v2020.2   bcb758ad2ada   About a minute ago   79.9GB
	-----------------------------------
	Image Build Complete...
	STARTED :Sun 17 Jan 2021 12:38:22 AM EST
	ENDED   :Sun 17 Jan 2021 03:26:25 AM EST
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vitis_v2020.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vitis_v2020-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vitis:v2020.2 \
	/bin/bash
8d9e932d300531b3b85cce4c994606159613274b8986ec79e6abeee0c1dc1938
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                  COMMAND       CREATED          STATUS          PORTS     NAMES
8d9e932d3005   xilinx-vitis:v2020.2   "/bin/bash"   19 seconds ago   Up 15 seconds             xilinx_vitis_v2020.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vitis_v2020.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
xilinx@xilinx_vitis_v2020-2:/opt/Xilinx$
```

## Execute Vitis Tools
- Launch Vitis from the working container
```bash
xterm:
xilinx@xilinx_vitis_v2020-2:/opt/Xilinx$ vitis

****** Xilinx Vitis Development Environment
****** Vitis v2020.2 (64-bit)
  **** SW Build 3064172 on 2020-11-18-06:24:19
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

Launching Vitis with command /opt/Xilinx/Vitis/2020.2/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx1024m -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false -Dosgi.configuration.area=@user.home/.Xilinx/Vitis/2020.2 --add-modules=ALL-SYSTEM --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.desktop/sun.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing.tree=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.synth=ALL-UNNAMED --add-opens=java.desktop/com.sun.awt=ALL-UNNAMED --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED &
xilinx@xilinx_vitis_v2020-2:/opt/Xilinx$
```

