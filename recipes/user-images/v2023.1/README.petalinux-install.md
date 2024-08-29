[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2023.1 Xilinx Tools)

# Install Petalinux
- Ref: [Petalinux 2023.1 Release Notes](https://support.xilinx.com/s/article/000035006?language=en_US)
- Ref: [Petalinux 2023.1 Installation Instructions](https://docs.amd.com/r/2023.1-English/ug1144-petalinux-tools-reference-guide/Installation-Requirements)

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG           IMAGE ID       CREATED          SIZE
xilinx-ubuntu-20.04.4-user   v2023.1       d1b4ab412c2d   5 days ago      2.97GB
ubuntu-iso                   20.04.4       c50b147a55dd   18 hours ago     946MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_tool_install_v2023.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_tool_install_v2023-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-20.04.4-user:v2023.1 \
	/bin/bash
8ce097e151be72a6756fbad99c56b5ed2c116d3374722089cf31eb00b9023ddc
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                COMMAND       CREATED          STATUS          PORTS     NAMES
                                                                                                                                                                                  NAMES
611d23e118a6   xilinx-ubuntu-20.04.4-user:v2023.1   "/bin/bash"   5 seconds ago    Up 5 seconds              xilinx_tool_install_v2023.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_tool_install_v2023.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_tool_install_v2023-1:/$
```

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_tool_install_v2023-1:/$ ls -al /srv/software/2023.1/petalinux*v2023.1*
-rwxrwxr-x. 1 xilinx xilinx 3412288971 May 23  2023 /srv/software/2023.1/petalinux-v2023.1-05012318-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_tool_install_v2023-1:/$ sudo mkdir -p /opt/tools/Xilinx/Petalinux/2023.1
xilinx@xilinx_tool_install_v2023-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer
- Specify the install directory using the `-d` option

```bash
xterm:
xilinx@xilinx_tool_install_v2023-1:/$ cd /opt/tools/Xilinx/
xilinx@xilinx_tool_install_v2023-1:/opt/tools/Xilinx$ /srv/software/2023.1/petalinux-v2023.1-05012318-installer.run --dir Petalinux/2023.1 --log petalinux_install.log
INFO: Checking installation environment requirements...
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144  PetaLinux Tools Documentation Reference Guide" for its impact and solution
INFO: Checking installer checksum...
INFO: Extracting PetaLinux installer...

LICENSE AGREEMENTS

PetaLinux SDK contains software from a number of sources.  Please review
the following licenses and indicate your acceptance of each to continue.

You do not have to accept the licenses, however if you do not then you may 
not use PetaLinux SDK.

Use PgUp/PgDn to navigate the license viewer, and press 'q' to close

Press Enter to display the license agreements
Do you accept Xilinx End User License Agreement? [y/N] > y
Do you accept Third Party End User License Agreement? [y/N] > y
INFO: Installing PetaLinux...
INFO: Checking PetaLinux installer integrity...
INFO: Installing PetaLinux SDK to "/opt/tools/Xilinx/Petalinux/2023.1/."
INFO: Installing buildtools in /opt/tools/Xilinx/Petalinux/2023.1/./components/yocto/buildtools
INFO: Installing buildtools-extended in /opt/tools/Xilinx/Petalinux/2023.1/./components/yocto/buildtools_extended
INFO: PetaLinux SDK has been installed to /opt/tools/Xilinx/Petalinux/2023.1/.
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_tool_install_v2023-1:/opt/tools/Xilinx$ echo ". /opt/tools/Xilinx/Petalinux/2023.1/settings.sh" >> ~/.bashrc
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installed to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_tool_install_v2023.1 xilinx-petalinux:v2023.1
sha256:ac3adff373febeee98b5cd653dd27794573377da2e405cea5d65c577770104ab
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG           IMAGE ID       CREATED         SIZE
xilinx-petalinux             v2023.1       9e068ce443b1   5 days ago      15.6GB
xilinx-ubuntu-20.04.4-user   v2023.1       d1b4ab412c2d   5 days ago      2.97GB
ubuntu-iso                   20.04.4       c50b147a55dd   18 months ago   946MB
```
