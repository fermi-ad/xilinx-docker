[//]: # (README.md - Vivado v2021.1 Build Environment)

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
	-> Xilinx_Unified_2021.2_1021_0703_Lin64.bin
	-> Xilinx_Unified_2021.2_1021_0703.tar.gz
	-> Xilinx_Unified_2021.2_1021_0703.tar.gz.sha256
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
	- Xilinx Unified Installer v2021.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2021.1_0610_2318_Lin64.bin
- Place the installer binary (or a link to it) in the ./depends folder
- Vivado v2021.1 Release Notes:
	- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug973-vivado-release-notes-install-license.pdf
	- https://www.xilinx.com/support/answers/76539.html

## Download Xilinx Unified All OS Single-File Download Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2021.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2021.1_0610_2318_Lin64.tar.gz
- Place the installer binary (or a link to it) in the ./depends folder
- Vivado v2021.1 Release Notes:
	- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug973-vivado-release-notes-install-license.pdf
	- https://www.xilinx.com/support/answers/76539.html

## Generate Unified Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2021.2_1021_0703.tar.gz depends/
$ ln -s <path-to-offline-installer>/XXilinx_Unified_2021.2_1021_0703.tar.gz.sha256 depends/
$ ln -s <path-to-offline-installer>/Xilinx_Unified_2021.2_1021_0703_Lin64.bin depends/
```

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__



## Generate an Ubuntu 18.04.5 user image 
- This contains all the dependencies for the v2021.2 Xilinx Tools

```bash
bash:
$ pushd ../../user-images/v2021.2/ubuntu-18.04.5-user
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
	- Select ```Vivado ML Standard```: option ```1```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```Modules=...DocNav:0,...``` 
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
-rw-r--r-- 1 xilinx xilinx 1511 Jun 30 11:06 _generated/configs/xlnx_unified_vivado.config
-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Build a v2021.2 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
	xilinx-vivado   v2021.2   387d57418d48   37 seconds ago   80.9GB
	-----------------------------------
	Image Build Complete...
	STARTED :Thu 11 Nov 2021 08:38:27 AM EST
	ENDED   :Thu 11 Nov 2021 09:50:34 AM EST
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_v2021.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2021-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vivado:v2021.2 \
	/bin/bash
a2094808483ce36e3bd7f30335c728a6b5a2e3699db89d27e1f4f8078fa4eca3
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a

```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container

```bash
bash:
$ docker exec -id xilinx_vivado_v2021.2 bash -c "xterm"
```

- This launches an X-windows terminal shell and sources the Vivado settings script

```bash
xterm:
xilinx@xilinx_vivado_v2021-2:/opt/Xilinx$ 
```

## Execute Vivado Tools
- Launch Vivado from the working container
```bash
xterm:
xilinx@xilinx_vivado_v2021-2:/opt/Xilinx$ vivado

****** Vivado v2021.2 (64-bit)
...
start_gui
```
