[//]: # (Readme.vivado-install.md - Install Vitis on a Base Ubuntu User Image for v2019.2 Xilinx Tools)

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

# Install Vitis

## Create a working container (running in daemon mode)

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        3 minutes ago       2.02GB
ubuntu                           18.04.2              76df73440f9c        12 days ago         88.3MB
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
	--name xilinx_vivado_install_v2019.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2019-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.2-user:v2019.2 \
	/bin/bash
16e4d2e625e61b10532414e8fe959d20632d432c1435a87f526fa619fc53fa24
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
16e4d2e625e6        xilinx-ubuntu-18.04.2-user:v2019.2   "/bin/bash"         27 seconds ago      Up 25 seconds                           xilinx_vivado_install_v2019.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_install_v2019.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/$
```

## Install Vivado

### Locate the unified installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/$  ls -al /srv/software/unified-installer/*2019.2*
-rwxrwxr-x 1 xilinx xilinx 121004693 Nov  1  2019 /srv/software/unified-installer/Xilinx_Unified_2019.2_1024_1831_Lin64.bin
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/$ sudo mkdir -p /opt/Xilinx
xilinx@xilinx_vivado_v2019-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the unified installer
- Select `Vivado` and `Vitis HL System Edition` during the installation
- Install to the `/opt/Xilinx` directory
- Uncheck

```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/$ cd /opt/Xilinx/
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ /srv/software/unified-installer/Xilinx_Unified_2019.2_1024_1831_Lin64.bin
Verifying archive integrity... All good.
Uncompressing Xilinx Installer...............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
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
	- Select the edition to install
		- ```Vivado HL System Edition```
		- Continue: ```Next```
	- Customize the install
		- Design Tools:
			- Deselect ```DocNav```
		- Installation Options:
			- Deselect ```Acquire or Manage a License Key```
			- Deselect ```Enable WebTalk for Vivado to send ...```
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
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ echo ". /opt/Xilinx/Vivado/2019.2/settings64.sh" > ~/.bashrc
```

### Turn off webtalk

### Initialize the Vivado paths
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ source /opt/Xilinx/Vivado/2019.2/settings64.sh
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ vivado -mode tcl

****** Vivado v2019.2 (64-bit)
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
INFO: [Common 17-206] Exiting Vivado at Thu Jul 16 12:12:13 2020...
```

### Install a License File(s)

### Launch Vivado

```bash
xterm:
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ vivado

****** Vivado v2019.2 (64-bit)
  **** SW Build 2700185 on Thu Oct 24 18:45:48 MDT 2019
  **** IP Build 2699827 on Thu Oct 24 21:16:38 MDT 2019
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
xilinx@xilinx_vivado_v2019-2:/opt/Xilinx$ exit
```

# Create a Vitis Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installer to your repository 
- This creates a new `Docker Image` with Vitis installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_vivado_install_v2019.2 xilinx-vivado-licensed:v2019.2
sha256:3d64cba62109a12b608977874e3754afbc8c957d5d82898c700a2eff25bf73b6
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed           v2019.2              b35a36751e77        3 seconds ago       40.9GB
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        3 minutes ago       2.02GB
ubuntu                           18.04.2              76df73440f9c        12 days ago         88.3MB
```