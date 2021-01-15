[//]: # (README.md - Vivado v2020.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> Dockerfile.base.generate_configs
-> Dockerfile.iso.generate_configs
-> generate_configs.sh
-> configs/
	-> xlnx_unified_vivado.config
-> depends/
	-> Xilinx_Unified_2020.2_1118_1232_Lin64.bin
	-> Xilinx_Unified_2020.2_1118_1232_Lin64.tar.gz
-> include/
	-> configuration.sh
```

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
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.1_0602_1208_Lin64.bin
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.1 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/wlk1553469789555.html

## Download Xilinx Unified All OS Single-File Download Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2020.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.2_1118_1232.tar.gz
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_2/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.1 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/wlk1553469789555.html

## Generate Unified Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2020.2_1118_1232_Lin64.tar.gz depends/
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2020.2_1118_1232_Lin64.bin depends/
```

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

## Generate Vivado Image Install Configuration Files (one time)

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh --iso
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
-rw-r--r-- 1 xilinx xilinx 1888 Jan 15 10:43 _generated/configs/xlnx_unified_vivado.config
-----------------------------------

```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Build a v2020.1 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	xilinx-vivado       v2020.1             56428027c963        12 seconds ago      52.5GB
	-----------------------------------
	Image Build Complete...
	STARTED :Sat 21 Nov 2020 01:29:56 PM EST
	ENDED   :Sat 21 Nov 2020 02:43:38 PM EST
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_v2020.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2020-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vivado:v2020.1 \
	/bin/bash
cc6b51a1688a416a814e6ba704b6fe82ff5d59c65569522fe386700b4c0a405b
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
	CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
	49f7642b502b        xilinx-vivado:v2020.1   "/bin/bash"         8 seconds ago       Up 6 seconds                            xilinx_vivado_v2020.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container

```bash
bash:
$ docker exec -id xilinx_vivado_v2020.1 bash -c "xterm"
```

- This launches an X-windows terminal shell and sources the Vivado settings script

```bash
xterm:
xilinx@xilinx_vivado_v2020-1:/$
```

## Execute Vivado Tools
- Launch Vivado from the working container
```bash
xterm:
xilinx@xilinx_vivado_v2020-1:/opt/Xilinx$ vivado

****** Vivado v2020.1 (64-bit)
  **** SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
  **** IP Build 2902112 on Wed May 27 22:43:36 MDT 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

start_gui
```
