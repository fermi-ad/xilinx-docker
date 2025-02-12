[//]: # (Readme.vivado-install.md - Install Vivado on a Base Ubuntu User Image for v2019.1 Xilinx Tools)

# Install Vivado

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY          		 TAG                 IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.1-user   v2019.1             bc2b2473ce69        36 minutes ago      2.26GB
ubuntu              		 18.04.1             2a3d27e2eca9        23 hours ago        83.5MB
ubuntu-iso          		 18.04.1             b2b31f343d6a        23 hours ago        238MB
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
	--name xilinx_vivado_install_v2019.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2019-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.1-user:v2019.1 \
	/bin/bash
66ec71cee93a52aaf167e1d7f12ca7c45ff510268800ed0eab38cb8c553b44d0
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
66ec71cee93a        xilinx-ubuntu-18.04.1-user:v2019.1   "/bin/bash"         9 seconds ago       Up 7 seconds                            xilinx_vivado_install_v2019.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$  ls -al /srv/software/vivado/*2019.1*
-rwxrwxr-x 1 xilinx xilinx 120638336 May 29  2019 /srv/software/vivado/Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2019-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vivado HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ /srv/software/vivado/Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin
Verifying archive integrity... All good.
Uncompressing Xilinx Installer...........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
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
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2019.1/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ source /opt/Xilinx/Vivado/2019.1/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2019.1 (64-bit)
  **** SW Build 2700185 on Thu Oct 24 18:45:48 MDT 2019
  **** IP Build 2699827 on Thu Oct 24 21:16:38 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

Vivado% config_webtalk -user off
Vivado% config_webtalk -install off
Vivado% config_webtalk -info
INFO: [Common 17-1369] WebTalk has been disabled by the current user.
INFO: [Common 17-1370] WebTalk has been disabled for the current installation.
INFO: [Common 17-1366] This combination of user/install settings means that WebTalk is currently disabled.
Vivado% exit
exit
INFO: [Common 17-206] Exiting Vivado at Sun Jul 19 17:00:27 2020...
```

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ vivado

****** Vivado v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
  **** IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

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
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ exit
```

# Create a Vivado Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installer to your repository 
- This creates a new `Docker Image` with Vivado installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2019.1 xilinx-vivado-licensed:v2019.1
sha256:sha256:46d75ae2e08d409d9112aa8f777e25c848acf53362af2360c49215e0b9e8ca4c
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed           v2019.1              46d75ae2e08d        3 seconds ago       35.2GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        40 hours ago        2.02GB
ubuntu                           18.04.1              1f5eefc33d49        41 hours ago        83.5MB
```
