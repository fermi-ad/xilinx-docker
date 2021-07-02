[//]: # (Readme.vitis-install.md - Install Vitis on a Base Ubuntu User Image for v2021.1 Xilinx Tools)

# Install Vitis

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE
xilinx-ubuntu-20.04.1-user       v2021.1   0dd5b171751c   6 days ago     2.09GB
ubuntu-iso                       20.04.1   b22e81a44813   3 hours ago    267MB
ubuntu                           20.04.1   16d905ba1cbe   6 months ago   72.9MB
```

### Create a working vitis install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software/xilinx:/srv/software`
	- gives access to host files under `/srv/software/xilinx` in the Docker container
	- `/srv/software` is the mounted location inside of the Docker container
	- `/srv/software/xilinx/` is the location of the Xilinx tool installer binaries
	- `/srv/software/licenses/` is the location of the Xilinx license files

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vitis_install_v2021.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vitis_v2021-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-20.04.1-user:v2021.1 \
	/bin/bash
8fb2e18710aded4399d776cf6a39d28faf7af77a00c27b225046799fd1046466
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                    COMMAND       CREATED          STATUS          PORTS     NAMES
8fb2e18710ad   xilinx-ubuntu-20.04.1-user:v2021.1       "/bin/bash"   11 seconds ago   Up 9 seconds              xilinx_vitis_install_v2021.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vitis_install_v2021.1 bash -c "xterm" &
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
xilinx@xilinx_vitis_v2021-1:/$  ls -al /srv/software/unified/web/*2021.1*
-rwxrwxr-x 1 xilinx xilinx 315917102 Jun 25 13:54 /srv/software/unified/web/Xilinx_Unified_2021.1_0610_2318_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vitis_v2021-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vitis` and `Vitis HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/$ cd /opt/Xilinx/
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ /srv/software/unified/web/Xilinx_Unified_2021.1_0610_2318_Lin64.bin
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
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ echo ". /opt/Xilinx/Vitis/2021.1/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the Vitis paths
```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ source /opt/Xilinx/Vitis/2021.1/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2021.1 (64-bit)
  **** SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
  **** IP Build 3064653 on Wed Nov 18 14:17:31 MST 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

Vivado% 
Vivado% config_webtalk -user off
Vivado% config_webtalk -install off
Vivado% config_webtalk -info
INFO: [Common 17-1369] WebTalk has been disabled by the current user.
INFO: [Common 17-1370] WebTalk has been disabled for the current installation.
INFO: [Common 17-1366] This combination of user/install settings means that WebTalk is currently disabled.
Vivado% exit
exit
INFO: [Common 17-206] Exiting Vivado at Thu Jan 14 18:10:32 2021...
```

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ vivado

****** Vivado v2021.1 (64-bit)
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

## Exit the Xterm session
- The Xterm window can be closed

```bash
xterm:
xilinx@xilinx_vitis_v2021-1:/opt/Xilinx$ exit
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vitis installed to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vitis_install_v2021.1 xilinx-vitis-licensed:v2021.1
sha256:3abffebbfc512790a24afce6ed6162b5b9c91bb3244984dca54b4628d5216623
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED        		SIZE
xilinx-vitis-manual          v2021.1   3abffebbfc51   3 hours ago    		79.9GB
xilinx-ubuntu-20.04.1-user   v2021.1   70d07c214d28   About a minute ago    1.69GB
ubuntu-iso                   20.04.1   803d92d833cd   6 weeks ago           267MB
ubuntu                       20.04.1   16d905ba1cbe   6 weeks ago    	    72.9MB
```
