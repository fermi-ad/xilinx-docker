[//]: # (Readme.sdk-install.md - Install SDK on a Base Ubuntu User Image for v2019.1 Xilinx Tools)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> configs/
	-> .minirc.dfl
	-> keyboard_settings.conf
	-> XTerm
-> include/
	-> configuration.sh
```

# Install SDK

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        About an hour ago   2.02GB
ubuntu                           18.04.1              1f5eefc33d49        2 hours ago         83.5MB
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
	--name xilinx_sdk_install_v2019.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_sdk_v2019-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.1-user:v2019.1 \
	/bin/bash
3708d12b518bf91b0da8a3dd19a7f00f4ca2cc62710e5bf2e625d65fbd4e20c5
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
3708d12b518b        xilinx-ubuntu-18.04.1-user:v2019.1   "/bin/bash"         11 seconds ago      Up 10 seconds                           xilinx_sdk_install_v2019.1                           xilinx_sdk_install_v2019.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_sdk_install_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/$
```

## Install SDK

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/$ ls -al /srv/software/sdk/*2019.1*
-rwxrwxr-x 1 xilinx xilinx 113141511 May 29  2019 /srv/software/sdk/Xilinx_SDK_2019.1_0524_1430_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_sdk_v2019-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer

```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/$ cd /opt/Xilinx/
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$ /srv/software/unified-installer/Xilinx_Unified_2019.1_0602_1208_Lin64.bin
Verifying archive integrity... All good.
Uncompressing Xilinx Installer.........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
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
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$ echo ". /opt/Xilinx/SDK/2019.1/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the SDK paths
```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$ source /opt/Xilinx/SDK/2019.1/settings64.sh
```

### Launch XSDK

```bash
xterm:
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$ xsdk

****** Xilinx Software Development Kit
****** SDK v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

Launching SDK with command /opt/Xilinx/SDK/2019.1/eclipse/lnx64.o/eclipse -vmargs -Xms64m -Xmx4G -Dorg.eclipse.swt.internal.gtk.cairoGraphics=false &
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$
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
xilinx@xilinx_sdk_v2019-1:/opt/Xilinx$ exit
```

# Create a SDK Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with SDK installed to your repository 
- This creates a new `Docker Image` with SDK installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_sdk_install_v2019.1 xilinx-sdk:v2019.1
sha256:e8ce87d03b5e0c56f7962362c666f7f2708dbce78a11b6f04f7c2f089181dce2
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
xilinx-sdk                       v2019.1              e8ce87d03b5e        Less than a second ago   9.99GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        18 hours ago             2.02GB
ubuntu                           18.04.1              1f5eefc33d49        19 hours ago             83.5MB

```
