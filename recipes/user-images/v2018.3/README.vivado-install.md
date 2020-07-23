[//]: # (Readme.vivado-install.md - Install Vivado on a Base Ubuntu User Image for v2018.3 Xilinx Tools)

# Install Vivado

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED              SIZE
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        2 hours ago          1.61GB
ubuntu                           16.04.4              3bd5992802b9        9 hours ago          112MB
```

### Create a working vivado install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software/xilinx:/srv/software`
	- gives access to host files under `/srv/software/xilinx` in the Docker container
	- `/srv/software` is the mounted location inside of the Docker container
	- `/srv/software/xilinx/` is the location of the Xilinx tool installer binaries
	- `/srv/software/licenses/` is the location of the Xilinx license files

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_install_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.4-user:v2018.3 \
	/bin/bash
b333545e774d9310eb683c2b4a886db33d60b80f96fd6ae1570c1114c7df487c
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
b333545e774d        xilinx-ubuntu-16.04.4-user:v2018.3   "/bin/bash"         14 seconds ago      Up 12 seconds                           xilinx_vivado_install_v2018.3
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/$ ls -al /srv/software/vivado/*2018.3*
-rwxrwxr-x 1 xilinx xilinx 118026358 Dec 19  2018 /srv/software/vivado/Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2018-3:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vivado HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ /srv/software/vivado/Xilinx_Vivado_SDK_Web_2018.3_1207_2324_Lin64.bin 
Verifying archive integrity... All good.
Uncompressing Xilinx Installer...................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
INFO : Log file location - /home/xilinx/.Xilinx/xinstall/xinstall_1595521168985.log
```

### Install Vivado

- Xilinx Vivado Installer
	- This should launch an X11-based Xilinx Vivado Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download and Install Now```
	- Accept License Agreements
	- Select the product to install
		- ```Vivado```
	- Select the edition to install
		- ```Vivado HL System Edition```
		- Continue: ```Next```
	- Customize the install
		- Design Tools:
			- Deselect ```DocNav```
		- Installation Options:
			- Deselect ```Acquire or Manage a License Key```
			- Deselect ```Enable WebTalk for Vivado to send ...```
			- Deselect ```Enable WebTalk for SDK to send...```
		- Continue: ```Next```
	- Select Destination Directory
		- Installation Options
			- Select the installation directory: ```/opt/Xilinx```
		- Select shortcut and file association options
			- Uncheck ```Create program group entries```
			- Uncheck ```Create desktop shortcuts```
	- Continue: ```Next```	
	- If prompted to create the download directory (in the container): ```Yes```
	- Install: ```Install```
	- Finish the installation ```OK```

### Set vivado script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2018.3/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ source /opt/Xilinx/Vivado/2018.3/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2018.3 (64-bit)
  **** SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
  **** IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

Vivado% config_webtalk -user off
Vivado% config_webtalk -install off
Vivado% config_webtalk -info
INFO: [Common 17-1369] WebTalk has been disabled by the current user.
INFO: [Common 17-1370] WebTalk has been disabled for the current installation.
INFO: [Common 17-1366] This combination of user/install settings means that WebTalk is currently disabled.
Vivado% exit
exit
INFO: [Common 17-206] Exiting Vivado at Thu Jul 23 17:02:57 2020...
```

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ vivado

****** Vivado v2018.3 (64-bit)
  **** SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
  **** IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

start_gui
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
xilinx@xilinx_vivado_v2018-3:/opt/Xilinx$ exit
```

# Create a Vivado Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installer to your repository 
- This creates a new `Docker Image` with Vivado installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2018.3 xilinx-vivado-licensed:v2018.3
sha256:34239893fe3c45704d2d03a38bfb40775f22f7a2621865802db7c02a40bbfd34
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed           v2018.3              34239893fe3c        9 seconds ago       58.3GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        20 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        27 hours ago        112MB
```
