[//]: # (README.md - Vivado v2018.3 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_configs.sh
-> generate_installer.sh
-> Dockerfile
-> configs/
	-> xlnx_vivado.config
-> depends/
	-> Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.bin
	-> (Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.tar.gz)
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
	- https://www.xilinx.com/support/download/2018-3/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Vivado Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Vivado HLx Webpack Linux Installer v2018.3
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2018-3.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 16.04.4 image
- For Linux, execute the base image generation script __*../../base-images/ubuntu_16.04.4/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-16.04.4/
$ ./build_image.sh 
Base Relese Image Download [Good] ubuntu-base-16.04.4-base-amd64.tar.gz
+ docker import depends/ubuntu-base-16.04.4-base-amd64.tar.gz ubuntu:16.04.4
sha256:3bd5992802b9074965bc53c89729792526bbe75e89f3a0aae71b97af52af68e7
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.4              3bd5992802b9        Less than a second ago   112MB
```

## Generate an Ubuntu 16.04.4 user image (one time)
- Execute the image generation script __*../../../user-images/v2018.3/ubuntu-16.04.4-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2018.3/ubuntu-16.04.4-user/
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:16.04.4)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container 662dae904442
 ---> 3dfc6437d7c9
Successfully built 3dfc6437d7c9
Successfully tagged xilinx-ubuntu-16.04.4-user:v2018.3
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 20764
-----------------------------------
+ kill 20764
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 20764 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 22 17:32:15 EDT 2020
ENDED   :Wed Jul 22 17:36:40 EDT 2020
-----------------------------------

$ popd
```

## Generate Vivado Image Install Configuration Files (one time)

Note: Disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx Vivado batch mode configuration (generate)
	- Select ```Vivado HL System Edition```: option ```3```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0,Enable WebTalk for Vivado to send usage statistics to Xilinx (Always enabled for WebPACK license):0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=1```
	- Save with ```:wq```

- Review the generated configurations

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1795 Jul 24 10:29 _generated/configs/xlnx_vivado.config
-----------------------------------

```

- Copy the generated configurations to the dependency folder

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

- Xilinx Vivado Installer (download only)
	- This should launch an X11-based Xilinx Vivado Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Image (Install Separately)```
		- Use the following selections:
			- download directory: ```/opt/Xilinx/Downloads/v2018.3```
			- download files to create full image for selected platform(s): ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2018.3```
		- Disk Space Required:
			- ```Download Size: 19.08GB```
			- ```Disk Space Required: 19.08GB```
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
-rw-r--r-- 1 xilinx xilinx 20602506483 Jul 24 11:03 _generated/depends/Xilinx_Vivado_SDK_Web_2018.3_1207_2324.tar.gz
-----------------------------------
```

- Create a link to the offline installer in the dependency folder

```bash
bash:
$ ln -s ../_generated/depends/Xilinx_Vivado_SDK_Web_2018.3_1207_2324.tar.gz depends/
```

# Build a v2018.3 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built adfbef763ce7
Successfully tagged xilinx-vivado:v2018.3
...
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 24 11:10:00 EDT 2020
ENDED   :Fri Jul 24 11:35:48 EDT 2020
-----------------------------------
```

## Create a working container (running in daemon mode) based on the Vivado image
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
xilinx-vivado                    v2018.3              adfbef763ce7        2 hours ago         43.4GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        44 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        2 days ago          112MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vivado:v2018.3 \
	/bin/bash
6b90871291790988f2fc44c185135c5152aba226e404526427e1464e8a0ce833
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
6b9087129179        xilinx-vivado:v2018.3   "/bin/bash"         9 seconds ago       Up 7 seconds                            xilinx_vivado_v2018.3
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vivado settings script
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/$
```

## Execute Vivado Tools
- Launch Vivado from the working container
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ vivado

****** Vivado v2018.3 (64-bit)
  **** SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
  **** IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

start_gui
```
