[//]: # (README.md - Vivado v2019.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> Dockerfile.generate_configs
-> generate_configs.sh
-> generate_installer.sh
-> configs/
	-> xlnx_unified_vivado.config
-> depends/
	-> Xilinx_Unified_2019.2_1106_2127_Lin64.bin
	-> Xilinx_Vivado_2019.2_1106_2127.tar.gz
-> include/
	-> configuration.sh
```

## Need to determine Vivado dependencies?
### Download ldd-recursive.pl
https://downloads.sourceforge.net/project/recursive-ldd/ldd-recursive.pl?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Frecursive-ldd%2Ffiles%2Flatest%2Fdownload&ts=1537542905

### Run the ldd-recursive.pl script on the Vivado executable
```bash
bash:
$ perl ldd-recursive.pl /opt/Xilinx/Vivado/2019.2/bin/unwrapped/lnx64.o/vivado -uniq
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Vivado Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Unified Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2019.2_1106_2127_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder

## Download Xilinx Vivado HLx All OS Single-File Download Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Vivado_2019.2_1106_2127.tar.gz
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2019.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/wlk1553469789555.html

## Generate Unified/Vivado Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2019.2_1106_2127_Lin64.bin depends/
$ ln -s <path-to-offline-installer>/Xilinx_Vivado_2019.2_1106_2127.tar.gz depends/
```

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

## Generate Vivado Image Install Configuration Files (one time)

Note: in v2019.2, disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx Unified batch mode configuration (generate)
	- Select ```Vivado HL System Edition```: option ```3```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```Modules=...DocNav:0,...``` 
		- ```InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0,Enable WebTalk for Vivado to send usage statistics to Xilinx (Always enabled for WebPACK license):0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
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
-rw-r--r-- 1 xilinx xilinx 1839 Jul 16 16:17 _generated/configs/xlnx_unified_vivado.config
-----------------------------------

```

- Copy the generated configurations to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.2 user image (one time)
- Execute the image generation script __*../../../user-images/v2019.2/ubuntu-18.04.2-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2019.2/ubuntu-18.04.2-user/
$ ./build_image.sh 
-----------------------------------
Checking for configurations...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------
Docker Build Context (Working)...
-----------------------------------
...
Removing intermediate container f0caed766af2
 ---> 5d774cff76ff
Successfully built 5d774cff76ff
Successfully tagged xilinx-ubuntu-18.04.2-user:v2019.2
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 14815
-----------------------------------
+ kill 14815
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 14815 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Mon Jul 6 15:58:02 EDT 2020
ENDED   :Mon Jul 6 16:03:28 EDT 2020
-----------------------------------

$ popd
```

## Build a v2019.2 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	xilinx-vivado       v2019.2             23c8fcf5c7a9        31 seconds ago      41.1GB
	-----------------------------------
	Image Build Complete...
	STARTED :Mon 23 Nov 2020 12:14:01 AM EST
	ENDED   :Mon 23 Nov 2020 01:21:50 AM EST
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_v2019.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2019-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vivado:v2019.2 \
	/bin/bash
b1d1dd4a74aace828664acacc3c589f65e50ffbe0b2c16e2190c76cfd0b5367f
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
b1d1dd4a74aa        xilinx-vivado:v2019.2   "/bin/bash"         13 seconds ago      Up 11 seconds                           xilinx_vivado_v2019.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -id xilinx_vivado_v2019.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vivado settings script
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/$
```

## Execute Vivado Tools
- Launch Vivado from the working container
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ vivado 

****** Vivado v2019.2 (64-bit)
  **** SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
  **** IP Build 2700528 on Thu Nov  7 00:09:20 MST 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```
