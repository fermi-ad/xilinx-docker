[//]: # (Readme.vitis-install.md - Install Vitis on a Base Ubuntu User Image for v2021.2 Xilinx Tools)

# Install Vitis

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE
xilinx-ubuntu-18.04.5-user       v2021.2   0dd5b171751c   6 days ago     2.57GB
ubuntu-iso                       18.04.5   b22e81a44813   3 hours ago    267MB
ubuntu                           18.04.5   16d905ba1cbe   6 months ago   72.9MB
```

### Create a working vitis install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software:/srv/software`
	- gives access to installer and other Xilinx downloads on my host system under `/srv/software` in the Docker container
- Example: using `-v /xilinx:/xilinx`
	- gives access to vitis platforms, pre-builts, trds and working projects on my host system under `/xilinx` in the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vitis_install_v2021.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vitis_v2021-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software:/srv/software \
	-v /xilinx:/xilinx \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.5-user:v2021.2 \
	/bin/bash
11ba5120d25e2facd5dadcc066997d6b71a00810863f1cd2a24d4f57c9853253
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS                        PORTS     NAMES
11ba5120d25e   xilinx-ubuntu-18.04.5-user:v2021.2   "/bin/bash"              26 seconds ago   Up 25 seconds                           xilinx_vitis_install_v2021.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vitis_install_v2021.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$
```

## Install Vitis

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$  ls -al /srv/software/xilinx/2021.2/Xilinx_Unified*
-rwxrwxr-x 1 xilinx xilinx   286051682 Nov  2 13:48 /srv/software/xilinx/2021.2/Xilinx_Unified_2021.2_1021_0703_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$ sudo mkdir -p /opt/tools/Xilinx
xilinx@xilinx_vitis_v2021-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vitis` and `Vitis HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$ cd /opt/tools/Xilinx/
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ /srv/software/xilinx/2021.2/Xilinx_Unified_2021.2_1021_0703_Lin64.bin
Verifying archive integrity... All good.
Uncompressing Xilinx Installer..............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
```

### Install Vitis

- Xilinx Unified Installer
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download and Install Now```
	- Select the product to install
		- ```Vitis```
		- Continue: ```Next```
	- Deselect ```DocNav```
		- Continue: ```Next```
	- Accept License Agreements
	- Select Destination Directory
		- Installation Options
			- Select the installation directory: ```/opt/tools/Xilinx```
		- Select shortcut and file association options
			- Uncheck ```Create program group entries```
			- Uncheck ```Create desktop shortcuts```
	- Continue: ```Next```	
	- Create the download directory (in the container) when prompted: ```Yes```
	- Install: ```Install```
	- Finish the installation ```OK```

- Notes
	- Download Size: 64.39GB
	- Disk Space Required: 256.28GB
	- Final Disk Usage: 113.41GB

### Set vitis script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ echo ". /opt/tools/Xilinx/Vitis/2021.2/settings64.sh" > ~/.bashrc
```

### Set vitis platfor path for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ echo "export PLATFORM_REPO_PATHS=/xilinx/local/platforms/2021.2" >> ~/.bashrc
```

### Address AR #73698
- Link: https://www.xilinx.com/support/answers/73698.html

```bash
xterm:
xilinx@xilinx_vitis_v2020-2:/opt/Xilinx$ echo "export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu"
```

### Turn off webtalk
- Note: Webtalk has been removed from 2021.2

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ vivado

****** Vivado v2021.2 (64-bit)
  **** SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
  **** IP Build 3064653 on Wed Nov 18 14:17:31 MST 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

start_gui
```

### Open the License Manager

From the Vivado menu, select `Help` -> `Manage Licenses`

- Vivado License Manager
	- Get License -> Load License
	- Browse to `/srv/software/licenses`
	- Repeat for additional license files
	- Exit License Manager when done


## Install XRT (only needed for Alveo Cards)
- XRT Notes:
	- XRT inside of a docker container cannot access the host kernel, so it must be installed in the host OS and in the container.
	- Link: https://github.com/Xilinx/Xilinx_Base_Runtime#run-base-docker-image

### XRT Layered Communication Overview
- Note: This communication path only applies to FPGA-based PCIe cards in the Alveo family
- Note: Embedded platforms use the ZOCL driver and XRT is run on the embedded processor, not the host PC
- Host Machine: [XRT Driver] -> [FPGA Platform]
- Docker Container: [Application] -> [XRT Runtime] -> [Host: XRT Driver] -> [Host: FPGA Platform]

### Set XRT script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ echo ". /opt/tools/Xilinx/xrt/setup.sh" > ~/.bashrc
```

## Exit the Xterm session
- The Xterm window can be closed

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/tools/Xilinx$ exit
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vitis_install_v2021.2 xilinx-vitis-licensed:v2021.2
sha256:3abffebbfc512790a24afce6ed6162b5b9c91bb3244984dca54b4628d5216623
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED        		SIZE
xilinx-vitis-manual          v2021.2   3abffebbfc51   3 hours ago    		79.9GB
xilinx-ubuntu-18.04.5-user   v2021.2   70d07c214d28   About a minute ago    1.69GB
ubuntu-iso                   18.04.5   803d92d833cd   6 weeks ago           267MB
ubuntu                       18.04.5   16d905ba1cbe   6 weeks ago    	    72.9MB
```
