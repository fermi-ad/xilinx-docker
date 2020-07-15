[//]: # (README.md - Vitis v2020.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_configs.sh
-> host_xrt_setup.sh
-> Dockerfile
-> configs/
	-> .minirc.dfl
	-> keyboard_settings.conf
	-> xlnx_unified_vitis.config
	-> XTerm
-> depends/
	-> Xilinx_Unified_2020.1_0602_1208_Lin64.bin
	-> Xilinx_Unified_2020.1_0602_1208.tar.gz
	-> xrt_202010.2.6.655_18.04-amd64-xrt.deb
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
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.1_0602_1208.tar.gz
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.1 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/wlk1553469789555.html

## Download the Xilinx Runtime (XRT)
- The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
	- Pre-built XRT Ubuntu 18.04 Package for v2020.1
		- Installation Instructions:
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug1451-xrt-release-notes.pdf
		- Download Link:
			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_18.04-amd64-xrt.deb

### Reference - Building XRT from Source
- XRT can be built form source as an option
	- Instructions v2020.1:
		- https://xilinx.github.io/XRT/2020.1/html/index.html

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
- Execute the image generation script __*../../../user-images/v2020.1/ubuntu-18.04.2-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2020.1/ubuntu-18.04.2-user/
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
Successfully tagged xilinx-ubuntu-18.04.2-user:v2020.1
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

Note: in v2020.1, disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)
- Keyboard configuration
	- Select a keyboard model: ```Generic 105-key (Intl) PC``` is the default
	- Select a country of origin for the keyboard: ```English (US)``` is the default
	- Select a keyboard layout: ```English (US)``` is the default
	- Select an AltGr function: ```The default for the keyboard layout``` is the default
	- Select a compose key: ```No compose key``` is the default

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
-rw-r--r-- 1 xilinx xilinx 1554 Jul  3 09:47 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1797 Jul  3 09:57 _generated/configs/xlnx_unified_vitis.config
-----------------------------------

```

- Copy the generated configurations to the dependency folder

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
			- download directory: ```/opt/Xilinx/Downloads/v2020.1```
			- download files to create full image for selected platform(s): ```Linux```
			- image contents: ```Selected Product Only```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Select the product to install
		- ```Vitis```
		- Continue: ```Next```
	- Select edition to install
		- ```Vitis Unified Software Platform```
	- Futher configure the installation:
		- Design Tools
			- Uncheck DocNav
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2020.1```
		- Disk Space Required:
			- ```Download Size: 30.1GB```
			- ```Disk Space Required: 30.1GB```
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
-rw-r--r-- 1 xilinx xilinx 32461885648 Jul 10 21:43 _generated/depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz
-----------------------------------

```

- Create a link to the offline installer in the dependency folder

```bash
bash:
$ ln -s ../_generated/depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz depends/
```

## Build a v2020.1 Vitis Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built f1a8261359dd
Successfully tagged xilinx-vitis:v2020.1
...
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 15 07:56:39 EDT 2020
ENDED   :Wed Jul 15 09:18:34 EDT 2020
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
xilinx-vitis                     v2020.1              cb7829fd7257        15 minutes ago      71.3GB
xilinx-ubuntu-18.04.2-user       v2020.1              371b01c68a88        2 days ago          2.01GB
ubuntu                           18.04.2              c31ac5f5c1b0        4 days ago          88.3MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vitis_v2020.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vitis_v2020-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vitis:v2020.1 \
	/bin/bash
e2dbfb4434279a519b2350849ff5f04e45727c71e4b6009f59c34481e0bc14db
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS               NAMES
e2dbfb443427        xilinx-vitis:v2020.1   "/bin/bash"         11 seconds ago      Up 9 seconds                            xilinx_vitis_v2020.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vitis_v2020.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
xilinx@xilinx_vitis_v2020-1:/$
```

## Execute Vitis Tools
- Launch Vitis from the working container
```bash
xterm:
xilinx@xilinx_vitis_v2020-1:/opt/Xilinx$ vitis

****** Xilinx Vitis Development Environment
****** Vitis v2020.1 (64-bit)
  **** SW Build 2902540 on Wed May 27 19:55:13 MDT 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

Launching Vitis with command /opt/Xilinx/Vitis/2020.1/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false -Dosgi.configuration.area=@user.home/.Xilinx/Vitis/2020.1 --add-modules=ALL-SYSTEM --add-modules=jdk.incubator.httpclient --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.desktop/sun.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.desktop/javax.swing.tree=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.basic=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.synth=ALL-UNNAMED --add-opens=java.desktop/com.sun.awt=ALL-UNNAMED --add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED &
xilinx@xilinx_vitis_v2020-1:/opt/Xilinx$
```

