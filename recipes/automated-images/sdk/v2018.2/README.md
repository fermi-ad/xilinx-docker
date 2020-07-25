[//]: # (README.md - XSDK v2018.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_configs.sh
-> generate_installer.sh
-> Dockerfile
-> configs/
   -> xlnx_xsdk.config 
-> depends/
   -> Xilinx_SDK_2018.2_1207_2324_Lin64.bin
   -> (Xilinx_SDK_2018.2_1207_2324_Lin64.tar.gz)
-> include/
   -> configuration.sh
```

# Quickstart
## Download Xilinx SDK Web Installer

Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.

## Download the v2018.2 Xilinx SDK Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx SDK v2018.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2018.2_0614_1954_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2018-2.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## Generate a base Ubuntu 16.04.3 image
- For Linux, execute the base image generation script __*../../base-images/ubuntu_16.04.3/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-16.04.3/
$ ./build_image.sh 
Base Release Image [Good] ubuntu-base-16.04.3-base-amd64.tar.gz
sha256:fc6c834c4aefbe1f8ea515d2a1898a6ef6ce55d8517597d0beab1f2840eab41b
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.3              8ce789b819ee        Less than a second ago   120MB
```

## Generate an Ubuntu 16.04.3 user image (one time)
- Execute the image generation script __*../../../user-images/v2018.2/ubuntu-16.04.3-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2018.2/ubuntu-16.04.3-user/
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:16.04.3)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container f96c895773d9
 ---> c63f60c67792
Successfully built c63f60c67792
Successfully tagged xilinx-ubuntu-16.04.3-user:v2018.2
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 20203
-----------------------------------
+ kill 20203
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 20203 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 22 19:52:15 EDT 2020
ENDED   :Wed Jul 22 19:56:45 EDT 2020
-----------------------------------

$ popd
```

## Generate SDK Image Install Configuration Files (one time)

Note: Disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx SDK batch mode configuration (generate)
	- Select ```Xilinx Software Development Kit```: option ```1```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```Modules=...DocNav:0,...``` 
		- ```InstallOptions=Enable WebTalk for SDK to send usage statistics to Xilinx:0```
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
-rw-r--r-- 1 xilinx xilinx 1245 Jul 25 14:08 _generated/configs/xlnx_xsdk.config
-----------------------------------
```

- Copy the generated configurations to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate SDK Offline Installer Bundle (one time)

### Execute the installer generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_installer.sh
```

- Xilinx SDK Installer (download only)
	- This should launch an X11-based Xilinx SDK Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Image (Install Separately)```
		- Use the following selections:
			- download directory: ```/opt/Xilinx/Downloads/v2018.2```
			- download files to create full image for selected platform(s): ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2018.2```
		- Disk Space Required:
			- ```Download Size: 1.22GB```
			- ```Disk Space Required: 1.22GB```
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
-rw-r--r-- 1 xilinx xilinx 1398792065 Jul 25 14:14 _generated/depends/Xilinx_SDK_2018.2_0614_1954_Lin64.tar.gz
-----------------------------------
```

# Build a v2018.2 SDK Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built 0909b274da2e
Successfully tagged xilinx-xsdk:v2018.2
...
-----------------------------------
Image Build Complete...
STARTED :Sat Jul 25 14:17:29 EDT 2020
ENDED   :Sat Jul 25 14:21:38 EDT 2020
-----------------------------------
```

## Create a working container (running in daemon mode) based on the SDK image
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
xilinx-xsdk                      v2018.2              0909b274da2e        3 hours ago         10.4GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        2 days ago          1.62GB
ubuntu                           16.04.3              8ce789b819ee        3 days ago          120MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_xsdk_v2018.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_xsdk_v2018-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-xsdk:v2018.2 \
	/bin/bash
89bad426ade8a951df698a89bc4bb8c8215a0c38b1b0cbf243c392b981eac481
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
89bad426ade8        xilinx-xsdk:v2018.2     "/bin/bash"         9 seconds ago       Up 8 seconds                            xilinx_xsdk_v2018.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_xsdk_v2018.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vivado settings script
```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/$
```

## Execute SDK Tools
- Launch SDK from the working container
```bash
xterm:
xilinx@xilinx_xsdk_v2018-2:/opt/Xilinx$ xsdk

****** Xilinx Software Development Kit
****** SDK v2018.2 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

Launching SDK with command /opt/Xilinx/SDK/2018.2/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false &
xilinx@xilinx_xsdk_v2018-2:/opt/Xilinx$
```
