[//]: # (Readme.sdk-install.md - Install SDK on a Base Ubuntu User Image for v2018.3 Xilinx Tools)

# Install SDK

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls

```

### Create a working sdk install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software/xilinx:/srv/software`
	- gives access to host files under `/srv/software/xilinx` in the Docker container
	- `/srv/software` is the mounted location inside of the Docker container
	- `/srv/software/xilinx/` is the location of the Xilinx tool installer binaries
	- `/srv/software/licenses/` is the location of the Xilinx license files

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_sdk_install_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_sdk_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.4-user:v2018.3 \
	/bin/bash
bd37bfcff966f9ed9e1edc8dc47127aa3dc405c490da4bdb4c4bf9a1e749f501
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
bd37bfcff966        xilinx-ubuntu-16.04.4-user:v2018.3   "/bin/bash"         17 seconds ago      Up 15 seconds                           xilinx_sdk_install_v2018.3
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_sdk_install_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/$
```

## Install SDK

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/$ ls -al /srv/software/sdk/*2018.3*
-rwxrwxr-x 1 xilinx xilinx 111621361 Dec 19  2018 /srv/software/sdk/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_sdk_v2018-3:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer

```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/$ cd /opt/Xilinx/
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$ /srv/software/sdk/Xilinx_SDK_2018.3_1207_2324_Lin64.bin 
Verifying archive integrity... All good.
Uncompressing Xilinx Installer.................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
INFO : Log file location - /home/xilinx/.Xilinx/xinstall/xinstall_1595526769037.log
```

### Install SDK

- Xilinx SDK Installer
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download and Install Now```
	- Accept License Agreements
	- Select the product to install
		- ```Xilinx Software Development Kit (XSDK)```
		- Continue: ```Next```
	- Customize your installation...
		- Design Tools
			- Deselect ```DocNav```
		- Installation Options
			- Deselect ```Enable WebTalk for SDK to send usage statistics to Xilinx```
		- Continue: ```Next```
	- Select Destination Directory
		- Installation Options
			- Select the installation directory: ```/opt/Xilinx```
		- Select shortcut and file association options
			- Uncheck ```Create program group entries```
			- Uncheck ```Create desktop shortcuts```
	- Continue: ```Next```	
	- Create the download directory (in the container) when prompted: ```Yes```
	- Install: ```Install```
	- Finish the installation ```OK```

### Set sdk script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$ echo ". /opt/Xilinx/SDK/2018.3/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the SDK paths
```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$ source /opt/Xilinx/SDK/2018.3/settings64.sh
```

### Launch XSDK

```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$ xsdk

****** Xilinx Software Development Kit
****** SDK v2018.3 (64-bit)
  **** SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

Launching SDK with command /opt/Xilinx/SDK/2018.3/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false &
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$
```

### Disable Webtalk/User Survey

- Accept the default workspace location
- From the XSDK menu, select
	- `Help` -> `Enable Webtalk`
	- `Help` -> `Enable User Survey`
	- `File` -> `Exit`

## Exit the Xterm session
- The Xterm window can be closed

```bash
xterm:
xilinx@xilinx_sdk_v2018-3:/opt/Xilinx$ exit
```

# Create a SDK Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with SDK installed to your repository 
- This creates a new `Docker Image` with SDK installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_sdk_install_v2018.3 xilinx-sdk:v2018.3
sha256:5dd0423d71b36e8298c1ce8f9ba25b430ff2ec089ff64b10afbb91d580ad6c91
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-sdk                       v2018.3              5dd0423d71b3        22 seconds ago      12.2GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        20 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        27 hours ago        112MB
```
