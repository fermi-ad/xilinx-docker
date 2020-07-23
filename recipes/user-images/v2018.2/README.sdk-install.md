[//]: # (Readme.sdk-install.md - Install SDK on a Base Ubuntu User Image for v2018.2 Xilinx Tools)

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
	--name xilinx_sdk_install_v2018.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_sdk_v2018-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.3-user:v2018.2 \
	/bin/bash
50e911445104cac5baed920254f2bebdc6af6fff866ec25b7e484cc95121d3bb
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
50e911445104        xilinx-ubuntu-16.04.3-user:v2018.2   "/bin/bash"         37 seconds ago      Up 34 seconds                           xilinx_sdk_install_v2018.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_sdk_install_v2018.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/$
```

## Install SDK

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/$ ls -al /srv/software/sdk/*2018.2*
-rwxrwxr-x 1 xilinx xilinx 104117777 Oct 29  2018 /srv/software/sdk/Xilinx_SDK_2018.2_0614_1954_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_sdk_v2018-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer

```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/$ cd /opt/Xilinx/
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$ /srv/software/sdk/Xilinx_SDK_2018.2_0614_1954_Lin64.bin 
Verifying archive integrity... All good.
Uncompressing Xilinx Installer......................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
INFO : Log file location - /home/xilinx/.Xilinx/xinstall/xinstall_1595526757691.log
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
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$ echo ". /opt/Xilinx/SDK/2018.2/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the SDK paths
```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$ source /opt/Xilinx/SDK/2018.2/settings64.sh
```

### Launch XSDK

```bash
xterm:
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$ xsdk

****** Xilinx Software Development Kit
****** SDK v2018.2 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

Launching SDK with command /opt/Xilinx/SDK/2018.2/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false 
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$
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
xilinx@xilinx_sdk_v2018-2:/opt/Xilinx$ exit
```

# Create a SDK Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with SDK installed to your repository 
- This creates a new `Docker Image` with SDK installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_sdk_install_v2018.2 xilinx-sdk:v2018.2
sha256:9b333040c9904363648ea1213115072086cb2e960c8f8d7dcefe8c6e0ae282be
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-sdk                       v2018.2              9b333040c990        40 seconds ago      12GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        18 hours ago        1.62GB
ubuntu                           16.04.3              8ce789b819ee        27 hours ago        120MB
```
