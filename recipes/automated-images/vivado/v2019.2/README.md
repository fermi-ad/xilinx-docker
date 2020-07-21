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
	-> Xilinx_Unified_2019.2_1024_1831_Lin64.bin
	-> (Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz)
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
			- https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Unified_2019.2_1024_1831_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 18.04.2 image (one time)
- Execute the image generation script __*../../base-images/ubuntu_18.04.2/build_image.sh*__

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

## Generate Vivado Image Install Configuration Files (one time)

Note: in v2019.2, disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx Vivado batch mode configuration (generate)
	- Select Vivado HL System Edition: option ```3```
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
-rw-r--r-- 1 xilinx xilinx 1839 Jul 16 17:27 _generated/configs/xlnx_unified_vivado.config
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate Vivado Offline Installer Bundle (one time)

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
		- ```Vivado```
		- Continue: ```Next```
	- Select edition to install
		- ```Vivado HL System Edition```
	- Futher configure the installation:
		- Design Tools
			- Uncheck DocNav
		- Installation Options
			- Uncheck Enable WebTalk...
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
Xilinx offline installer generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 29365120859 Jul 16 21:50 _generated/depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz
-----------------------------------

```

- Create a link to the offline installer in the dependency folder

```bash
bash:
$ ln -s ../_generated/depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz depends/
```

## Build a v2019.2 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built c2723ed456ea
Successfully tagged xilinx-vivado:v2019.2
...
-----------------------------------
Image Build Complete...
STARTED :Thu Jul 16 22:36:23 EDT 2020
ENDED   :Thu Jul 16 23:14:53 EDT 2020
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
xilinx-vivado                    v2019.2              c2723ed456ea        51 minutes ago      40.9GB
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        32 hours ago        2.02GB
ubuntu                           18.04.2              c31ac5f5c1b0        4 days ago          88.3MB
```

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
$ docker exec -it xilinx_vivado_v2019.2 bash -c "xterm" &
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
  **** SW Build 2700185 on Thu Oct 24 18:45:48 MDT 2019
  **** IP Build 2699827 on Thu Oct 24 21:16:38 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```
