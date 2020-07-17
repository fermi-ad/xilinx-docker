[//]: # (README.md - Vitis v2019.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> host_xrt_setup.sh
-> Dockerfile
-> configs/
	-> xlnx_unified_vitis.config
-> depends/
	-> Xilinx_Unified_2019.2_1024_1831_Lin64.bin
	-> (Vitis_Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz)
	-> xrt_201920.2.3.1301_18.04-xrt.deb
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
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2019.2_1106_2127_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2019.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk300137739.html


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
- Execute the image generation script __*../../../base-images/ubuntu_18.04.2/build_image.sh*__

```bash
$ pushd ../../../base-images/ubuntu-18.04.2
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-18.04.2-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz -O depends/ubuntu-base-18.04.2-base-amd64.tar.gz
--2019-12-18 10:20:17--  http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 2001:67c:1360:8001::27, 2001:67c:1560:8001::1d, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 31858560 (30M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’

depends/ubuntu-base-18.04.2-base-amd64.tar.gz            100%[=================================================================================================================================>]  30.38M  18.9MB/s    in 1.6s    

2019-12-18 10:20:18 (18.9 MB/s) - ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’ saved [31858560/31858560]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.2-base-amd64.tar.gz ubuntu:18.04.2
sha256:1c767f5d46fef0b75f5a1ab0f971b79f5fe3343f90c2861842713c6be7cf2a46
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.2              1c767f5d46fe        Less than a second ago   88.3MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   88.3MB              0B (0%)
Containers          0                   0                   0B            	 	0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

$ popd
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

## Generate Vitis Offline Installer Bundle (one time)

### Execute the installer generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_installer.sh
```

- Xilinx Unified Installer (download only)
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Image (Install Separately)```
		- Use the following selections:
			- download directory: ```/opt/Xilinx/Downloads/v2019.2```
			- download files to create full image for selected platform(s): ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Select the product to install
		- ```Vitis```
		- Continue: ```Next```
	- Futher configure the installation:
		- Design Tools
			- Vitis Unified Software Platform
				- Check ```System Generator for DSP```
		- Uncheck ```DocNav```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2019.2```
		- Disk Space Required:
			- ```Download Size: 27.22GB```
			- ```Disk Space Required: 27.22GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated installer bundle

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 29365118015 Jul 17 09:55 _generated/depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz
-----------------------------------

```

## Build a v2019.2 Vitis Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built 4d6c43867fe3
Successfully tagged xilinx-vitis:v2019.2
...
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 17 11:00:17 EDT 2020
ENDED   :Fri Jul 17 11:45:51 EDT 2020
-----------------------------------
```

## Create a working container (running in daemon mode) based on the vitis image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software/xilinx:/srv/software`
	- gives access to host files under `/srv/software/xilinx` in the Docker container
	- `/srv/software` is the mounted location inside of the Docker container
	- `/srv/software/xilinx/` is the location of the Xilinx installers, bsps, etc...
	- `/srv/software/licenses/` is the location of the Xilinx license files

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vitis                     v2019.2              4d6c43867fe3        29 minutes ago      55.2GB
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        44 hours ago        2.02GB
ubuntu                           18.04.2              c31ac5f5c1b0        4 days ago          88.3MB
```

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
