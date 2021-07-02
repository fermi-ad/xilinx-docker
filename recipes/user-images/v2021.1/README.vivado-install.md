[//]: # (Readme.vivado-install.md - Install Vivado on a Base Ubuntu User Image for v2021.1 Xilinx Tools)

# Install Vivado

## Create a working container (running in daemon mode) based on the vivadoimage

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE
xilinx-ubuntu-20.04.1-user       v2021.1   0dd5b171751c   6 days ago     2.09GB
ubuntu-iso                       20.04.1   b22e81a44813   3 hours ago    267MB
ubuntu                           20.04.1   16d905ba1cbe   6 months ago   72.9MB
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
	--name xilinx_vivado_install_v2021.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2021-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-20.04.1-user:v2021.1 \
	/bin/bash
4bfe23a8d62c4a6553db6cda3fe61f091f1e86b3327f446bc01c0da90ef03010
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND       CREATED          STATUS          PORTS     NAMES
4bfe23a8d62c   xilinx-ubuntu-20.04.1-user:v2021.1   "/bin/bash"   13 seconds ago   Up 11 seconds             xilinx_vivado_install_v2021.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2021.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/$  ls -al /srv/software/unified/web/*2020.2*
-rwxrwxr-x 1 xilinx xilinx 315917102 Jun 25 09:54 /srv/software/install/xilinx/unified/web/Xilinx_Unified_2021.1_0610_2318_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2021-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vivado ML Standard` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2021-1:/opt/Xilinx$  /srv/software/unified/web/Xilinx_Unified_2021.1_0610_2318_Lin64.bin 
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
		- ```Vivado HL Standard```
	- Use default configuration for ```Vivado ML Standard```
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
xilinx@xilinx_vivado_v2021-1:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2021.1/settings64.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/opt/Xilinx$ source /opt/Xilinx/Vivado/2021.1/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2021.1 (64-bit)
  **** SW Build 3247384 on Thu Jun 10 19:36:07 MDT 2021
  **** IP Build 3246043 on Fri Jun 11 00:30:35 MDT 2021
    ** Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.

Vivado% 
Vivado% config_webtalk -user off
Vivado% config_webtalk -install off
Vivado% config_webtalk -info
INFO: [Common 17-1369] WebTalk has been disabled by the current user.
INFO: [Common 17-1370] WebTalk has been disabled for the current installation.
INFO: [Common 17-1366] This combination of user/install settings means that WebTalk is currently disabled.
Vivado% exit
exit
```

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_vivado_v2021-1:/opt/Xilinx$ exit
```

# Create a Vivado Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Vivado installed to your repository 
- This creates a new `Docker Image` with Vivado installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2021.1 xilinx-vivado-licensed:v2021.1
sha256:a4831b0d125bce65f3495da955399e0b763710f768d4722ba08aba70ca7f651b
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE

xilinx-ubuntu-20.04.1-user       v2021.1   0dd5b171751c   6 days ago     2.09GB
ubuntu-iso                       20.04.1   b22e81a44813   3 hours ago    267MB
ubuntu                           20.04.1   16d905ba1cbe   6 months ago   72.9MB
```
