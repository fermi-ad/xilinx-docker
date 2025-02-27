[//]: # (Readme.vitis-install.md - Install Vitis on a Base Ubuntu User Image for v2022.2 Xilinx Tools)

# Install Vitis
- Ref: [Vitis 2022.2 Release Notes](https://docs.amd.com/r/2022.2-English/ug1307-vitis-p4-install/Release-Notes-and-Known-Issues)
- Ref: [Vitis 2022.2 Installation Instructions](https://docs.amd.com/r/2022.2-English/ug1393-vitis-application-acceleration/Installation)

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                                 IMAGE ID       CREATED          SIZE
xilinx-ubuntu-18.04.5-user   v2022.2                             1355be4e640c   24 minutes ago   2.84GB
ubuntu-iso                   18.04.5                             c50b147a55dd   18 hours ago     946MB
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
	--name xilinx_tool_install_v2022.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_tool_install_v2022-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.5-user:v2022.1 \
	/bin/bash
8ce097e151be72a6756fbad99c56b5ed2c116d3374722089cf31eb00b9023ddc
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND       CREATED          STATUS          PORTS     NAMES
8ce097e151be   xilinx-ubuntu-18.04.5-user:v2022.2   "/bin/bash"   26 seconds ago   Up 25 seconds             xilinx_tool_install_v2022.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_tool_install_v2022.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$
```

## Install Vitis

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$  ls -al /srv/software/2022.2/Xilinx_Unified*
-rw-r--r--. 1 xilinx xilinx    278858784 Aug 22 17:48 /srv/software/2022.2/Xilinx_Unified_2022.2_1014_8888_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_tool_install_v2022-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vitis` and `Vitis HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$ cd /opt/Xilinx/
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ /srv/software/2022.2/Xilinx_Unified_2022.2_1014_8888_Lin64.bin 
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
			- Select the installation directory: ```/opt/Xilinx```
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
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ echo ". /opt/Xilinx/Vitis/2022.2/settings64.sh" >> ~/.bashrc
```

### Set vitis platform path for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ echo "export PLATFORM_REPO_PATHS=/xilinx/local/platforms/2022.2" >> ~/.bashrc
```

### Address AR #73698
- Link: https://www.xilinx.com/support/answers/73698.html

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ echo "export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu" >> ~/.bashrc
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_tool_install_v2022.2 xilinx-tools:v2022.2
sha256:3abffebbfc512790a24afce6ed6162b5b9c91bb3244984dca54b4628d5216623
```

### Turn off webtalk
- Note: Webtalk has been removed from 2021.2+

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ vivado


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
xilinx@xilinx_vitis_v2022-2:/opt/Xilinx$ exit
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vitis_install_v2022.2 xilinx-vitis-licensed:v2022.2
sha256:3abffebbfc512790a24afce6ed6162b5b9c91bb3244984dca54b4628d5216623
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                        TAG           IMAGE ID       CREATED         SIZE
xilinx-tools-licensed             v2022.2       8e1530369a18   1 days ago      184GB
xilinx-tools                      v2022.2       06ce3428ef52   2 days ago      184GB
xilinx-petalinux                  v2022.2       9e068ce443b1   5 days ago      15.6GB
xilinx-ubuntu-18.04.5-user        v2022.2       d1b4ab412c2d   5 days ago      2.71GB
ubuntu-iso                   18.04.5       c50b147a55dd   18 months ago   946MB
```
