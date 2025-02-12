[//]: # (Readme.vivado-install.md - Install Vivado on a Base Ubuntu User Image for v2020.1 Xilinx Tools)

# Install Vivado

## Create a working container (running in daemon mode) based on the vivadoimage

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED              SIZE
xilinx-ubuntu-18.04.2-user   v2020.2             ef89bd6212a9        2 days ago          2.26GB
ubuntu-iso                   18.04.2             e349972b7588        2 days ago          243MB
ubuntu                       18.04.2             d1afd0299433        23 hours ago        88.3MB
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
	--name xilinx_vivado_install_v2020.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2020-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.2-user:v2020.2 \
	/bin/bash
4bfe23a8d62c4a6553db6cda3fe61f091f1e86b3327f446bc01c0da90ef03010
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND       CREATED          STATUS          PORTS     NAMES
4bfe23a8d62c   xilinx-ubuntu-18.04.2-user:v2020.2   "/bin/bash"   13 seconds ago   Up 11 seconds             xilinx_vivado_install_v2020.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2020.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/$  ls -al /srv/software/unified/web/*2020.2*
-rwxrwxr-x 1 xilinx xilinx 371283051 Dec  2 00:32 /srv/software/unified/web/Xilinx_Unified_2020.2_1118_1232_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2020-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vivado HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2020-2:/opt/Xilinx$  /srv/software/unified/web/Xilinx_Unified_2020.2_1118_1232_Lin64.bin 
Verifying archive integrity... All good.
Uncompressing Xilinx Installer..............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
```

### Install Vivado

- Xilinx Unified Installer
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download and Install Now```
	- Accept License Agreements
	- Select the product to install
		- ```Vivado```
		- Continue: ```Next```
	- Select edition to install
		- ```Vivado HL System Edition```
	- Use default configuration for ```Vivado HL System Edition```
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

### Install a License File(s)

- Vivado License Manager
	- Get License -> Load License
	- Browse to `/srv/software/licenses`
	- Repeat for additional license files
	- Exit License Manager when done


## Set vivado script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2020.2/settings64.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/opt/Xilinx$ source /opt/Xilinx/Vivado/2020.2/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2020.2 (64-bit)
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

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_vivado_v2020-2:/opt/Xilinx$ exit
```

# Create a Vivado Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vivado installed to your repository 
- This creates a new `Docker Image` with Vivado installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2020.2 xilinx-vivado-licensed:v2020.2
sha256:a4831b0d125bce65f3495da955399e0b763710f768d4722ba08aba70ca7f651b
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG       IMAGE ID       CREATED        		SIZE
xilinx-vivado-manual         v2020.2   a4831b0d125b   4 hours ago    		69.9GB
xilinx-ubuntu-18.04.2-user   v2020.2   70d07c214d28   About a minute ago    1.69GB
ubuntu-iso                   18.04.2   803d92d833cd   6 weeks ago           267MB
ubuntu                       18.04.2   16d905ba1cbe   6 weeks ago    	    72.9MB
```
