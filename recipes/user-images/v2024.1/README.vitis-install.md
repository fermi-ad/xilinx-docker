[//]: # (Readme.vitis-install.md - Install Vitis on a Base Ubuntu User Image for v2024.1 Xilinx Tools)

# Install Vitis
- Ref: [Vitis 2024.1 Release Notes](https://docs.amd.com/r/2024.1-English/ug1307-vitis-p4-install/Release-Notes-and-Known-Issues)
- Ref: [Vitis 2024.1 Installation Instructions](https://docs.amd.com/r/2024.1-English/ug1393-vitis-application-acceleration/Installation)

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG           IMAGE ID       CREATED          SIZE
xilinx-ubuntu-20.04.4-user   v2024.1       2cdba43a1a31   5 minutes ago    2.98GB
ubuntu-iso                   20.04.4       c50b147a55dd   19 months ago    946MB
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
	--name xilinx_tool_install_v2024.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_tool_install_v2024-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-20.04.4-user:v2024.1 \
	/bin/bash
72f88d0b812448e0b284f7a625040d14d9a5548093f7bc8a01ec39c665b0b872
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND       CREATED          STATUS          PORTS     NAMES
72f88d0b8124   xilinx-ubuntu-20.04.4-user:v2024.1   "/bin/bash"   26 seconds ago   Up 25 seconds             xilinx_tool_install_v2024.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_tool_install_v2024.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/$
```

## Install Vitis

### Locate the unified installer on the mounted host drive
- Note: Verify the installer is executable
```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/$  ls -al /srv/software/2024.1/FPGAs*
-rw-r--r--. 1 xilinx xilinx 305872385 Sep 30 17:31 /srv/software/2024.1/FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin
xilinx@xilinx_tool_install_v2024-1:/$ chmod a+x /srv/software/2024.1/FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin
```


### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/$ sudo mkdir -p /opt/tools/Xilinx
xilinx@xilinx_tool_install_v2024-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vitis` and `Vitis HL System Edition` during the installation
- Install to the `/opt/tools/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/$ cd /opt/tools/Xilinx/
xilinx@xilinx_tool_install_v2024-1:/opt/tools/Xilinx$ /srv/software/2024.1/FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin
Verifying archive integrity... All good.
Uncompressing AMD Installer for FPGAs and Adaptive SoCs..................................................................................................................................................................................................................................................................................................
```

### Install Vitis

- AMD Unified Installer for FPGAs & Adaptive SoCs 2024.1
	- This should launch an X11-based AMD Unified Installer Setup window on your host
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

### Set vitis script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/opt/tools/Xilinx$ echo ". /opt/tools/Xilinx/Vitis/2024.1/settings64.sh" >> ~/.bashrc
```

### Set vitis platform path for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/opt/tools/Xilinx$ echo "export PLATFORM_REPO_PATHS=/xilinx/local/platforms/2024.1" >> ~/.bashrc
```

### Address AR #73698
- Link: https://www.xilinx.com/support/answers/73698.html

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/opt/tools/Xilinx$ echo "export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu" >> ~/.bashrc
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_tool_install_v2024.1 xilinx-tools:v2024.1
sha256:0cf5febf3fcd9c348120df2ad2594cebc55dddad711af89568426862419d6478
```

### Turn off webtalk
- Note: Webtalk has been removed from 2021.2+

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_tool_install_v2024-1:/opt/tools/Xilinx$ vivado


```

### Open the License Manager

From the Vivado menu, select `Help` -> `Manage Licenses`

- Vivado License Manager
	- Get License -> Load License
	- Browse to `/srv/software/licenses`
	- Repeat for additional license files
	- Exit License Manager when done

## Exit the Xterm session
- The Xterm window can be closed

```bash
xterm:
xilinx@xilinx_vitis_v2024-1:/opt/tools/Xilinx$ exit
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vitis_install_v2024.1 xilinx-vitis-licensed:v2024.1
sha256:656db1c93935a639a5557c2cf1dc97e96b5ce958282d4cf2801c4af8341e7b86
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                        TAG           IMAGE ID       CREATED         SIZE
xilinx-tools-licensed             v2024.1       656db1c93935   2 hours ago     170GB
xilinx-tools                      v2024.1       0cf5febf3fcd   4 hours ago     170GB
xilinx-petalinux                  v2024.1       0c2d9e3c4637   8 hours ago     14.4GB
xilinx-ubuntu-20.04.4-user        v2024.1       2cdba43a1a31   9 hours ago     2.98GB
```
