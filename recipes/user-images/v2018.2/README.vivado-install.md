[//]: # (Readme.vivado-install.md - Install Vivado on a Base Ubuntu User Image for v2018.2 Xilinx Tools)

# Install Vivado

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED              SIZE
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        About a minute ago   1.62GB
ubuntu                           16.04.3              8ce789b819ee        9 hours ago          120MB
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
	--name xilinx_vivado_install_v2018.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2018-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.3-user:v2018.2 \
	/bin/bash
4d1b38cb553b4d4490ed548239f1bf61e7288259556aa1a9bb3d36fd93990318
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
4d1b38cb553b        xilinx-ubuntu-16.04.3-user:v2018.2   "/bin/bash"         35 seconds ago      Up 33 seconds                           xilinx_vivado_install_v2018.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2018.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/$ ls -al /srv/software/vivado/*2018.2*
-rwxrwxr-x 1 xilinx xilinx 104285843 Aug 14  2018 /srv/software/vivado/Xilinx_Vivado_SDK_Web_2018.2_0614_1954_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2018-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vivado HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ /srv/software/vivado/Xilinx_Vivado_SDK_Web_2018.2_0614_1954_Lin64.bin Verifying archive integrity... All good.
Uncompressing Xilinx Installer.......................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
INFO : Log file location - /home/xilinx/.Xilinx/xinstall/xinstall_1595521191502.log
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
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2018.2/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ source /opt/Xilinx/Vivado/2018.2/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2018.2 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
  **** IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

Vivado% config_webtalk -user off
Vivado% config_webtalk -install off
Vivado% config_webtalk -info
INFO: [Common 17-1369] WebTalk has been disabled by the current user.
INFO: [Common 17-1370] WebTalk has been disabled for the current installation.
INFO: [Common 17-1366] This combination of user/install settings means that WebTalk is currently disabled.
Vivado% exit
exit
INFO: [Common 17-206] Exiting Vivado at Thu Jul 23 17:02:24 2020..
```

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ vivado

****** Vivado v2018.2 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
  **** IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
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
xilinx@xilinx_vivado_v2018-2:/opt/Xilinx$ exit
```

# Create a Vivado Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installer to your repository 
- This creates a new `Docker Image` with Vivado installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2018.2 xilinx-vivado-licensed:v2018.2
sha256:ad3bd4fb3df3b65033b7c86faa307dafd9f066feda8ac12e05aed01a9cfc40e5
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed           v2018.2              ad3bd4fb3df3        6 seconds ago       54.5GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        17 hours ago        1.62GB
ubuntu                           16.04.3              8ce789b819ee        26 hours ago        120MB
```
