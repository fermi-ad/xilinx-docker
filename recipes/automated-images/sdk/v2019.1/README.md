[//]: # (README.md - XSDK v2019.1 Build Environment)

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
   -> Xilinx_SDK_2019.1_0524_1430_Lin64.bin
   -> (Xilinx_SDK_2019.1_0524_1430_Lin64.tar.gz)
-> include/
   -> configuration.sh
```

# Quickstart
## Download Xilinx SDK Web Installer

Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.

## Download the v2019.1 Xilinx SDK Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx SDK v2019.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2019.1_0524_1430_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2019-1.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## Generate a base Ubuntu 18.04.1 image (one time)
- For Linux, execute the base image generation script __*../../base-images/ubuntu_18.04.1/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-18.04.1/
$ ./build_image.sh 
Base Relese Image Download [Good] ubuntu-base-18.04.1-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.1-base-amd64.tar.gz ubuntu:18.04.1
sha256:4112b3ccf8569cf0e67fe5b99c011ab93a27dd42137ea26f88f070b52f8e15a8
+ docker image ls -a
REPOSITORY               TAG                 IMAGE ID            CREATED                  SIZE
ubuntu                   18.04.1             4112b3ccf856        Less than a second ago   83.5MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              12                  4                   123.5GB             87.35GB (70%)
Containers          4                   0                   743.1MB             743.1MB (100%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

$ popd
```+x
```

## Generate an Ubuntu 18.04.1 user image (one time)
- Execute the image generation script __*../../../user-images/v2019.1/ubuntu-18.04.1-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2019.2/ubuntu-18.04.2-user/
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.1)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container 344af33a95f3
 ---> 469af6a10c38
Successfully built 469af6a10c38
Successfully tagged xilinx-ubuntu-18.04.1-user:v2019.1
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 16058
-----------------------------------
+ kill 16058
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 16058 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 17 21:08:30 EDT 2020
ENDED   :Fri Jul 17 21:14:05 EDT 2020
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
		- ```EnableDiskUsageOptimization=1```
	- Save with ```:wq```

- Review the generated configurations

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1351 Jul 20 23:40 _generated/configs/xlnx_xsdk.config
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
			- download directory: ```/opt/Xilinx/Downloads/v2019.1```
			- download files to create full image for selected platform(s): ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2019.1```
		- Disk Space Required:
			- ```Download Size: 1.42GB```
			- ```Disk Space Required: 1.42GB```
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
-rw-r--r-- 1 xilinx xilinx 1643249692 Jul 21 12:42 _generated/depends/Xilinx_SDK_2019.1_0524_1430_Lin64.tar.gz
-----------------------------------

```

# Build a v2019.1 SDK Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built 596a4bcd648b
Successfully tagged xilinx-xsdk:v2019.1
...
-----------------------------------
Image Build Complete...
STARTED :Tue Jul 21 12:44:43 EDT 2020
ENDED   :Tue Jul 21 12:48:34 EDT 2020
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
xilinx-xsdk                      v2019.1              596a4bcd648b        3 minutes ago       9.96GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        3 days ago          2.02GB
ubuntu      					 18.04.1              1f5eefc33d49        3 days ago          83.5MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_xsdk_v2019.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_xsdk_v2019-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-xsdk:v2019.1 \
	/bin/bash
febf1ca10ed4568fdb6baad3f12c6dfe04b3b811d8be6328bf496a4356f6608e
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
febf1ca10ed4        xilinx-xsdk:v2019.1     "/bin/bash"         9 seconds ago       Up 8 seconds                            xilinx_xsdk_v2019.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_xsdk_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vivado settings script
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$
```

## Execute SDK Tools
- Launch SDK from the working container
```bash
xterm:
xilinx@xilinx_xsdk_v2019-1:/opt/Xilinx$ xsdk

****** Xilinx Software Development Kit
****** SDK v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

Launching SDK with command /opt/Xilinx/SDK/2019.1/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false &
xilinx@xilinx_xsdk_v2019-1:/opt/Xilinx$
```
