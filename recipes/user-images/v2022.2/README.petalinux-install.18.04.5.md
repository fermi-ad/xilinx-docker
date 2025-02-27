[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2022.2 Xilinx Tools)

# Install Petalinux
- Ref: [Petalinux 2022.2 Release Notes](https://support.xilinx.com/s/article/000034483?language=en_US)
- Ref: [Petalinux 2022.2 Installation Instructions](https://docs.xilinx.com/r/en-US/ug1144-petalinux-tools-reference-guide/Installation-Steps)

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                                 IMAGE ID       CREATED          SIZE
xilinx-ubuntu-18.04.5-user   v2022.2                             1355be4e640c   24 minutes ago   2.71GB
ubuntu-iso                   18.04.5                             c50b147a55dd   18 hours ago     946MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

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
	-itd xilinx-ubuntu-18.04.5-user:v2022.2 \
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

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$ ls -al /srv/software/2022.2/petalinux*v2022.2*
-rwxrwxr-x. 1 xilinx xilinx 2774984002 Nov 16  2022 /srv/software/2022.2/petalinux-v2022.2-10141622-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$ sudo mkdir -p /opt/Xilinx/Petalinux/2022.2
xilinx@xilinx_tool_install_v2022-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer
- Specify the install directory using the `-d` option

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/$ cd /opt/Xilinx/
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ /srv/software/2022.2/petalinux-v2022.2-10141622-installer.run --dir Petalinux/2022.2 --log petalinux_install.log
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
INFO: Installing PetaLinux SDK to "/opt/Xilinx/Petalinux/2022.2/."
INFO: Installing buildtools in /opt/Xilinx/Petalinux/2022.2/./components/yocto/buildtools
INFO: Installing buildtools-extended in /opt/Xilinx/Petalinux/2022.2/./components/yocto/buildtools_extended
INFO: PetaLinux SDK has been installed to /opt/Xilinx/Petalinux/2022.2/.
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_tool_install_v2022-2:/opt/Xilinx$ echo ". /opt/Xilinx/Petalinux/2022.2/settings.sh" > ~/.bashrc
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installed to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_tool_install_v2022.2 xilinx-petalinux:v2022.2
sha256:ac3adff373febeee98b5cd653dd27794573377da2e405cea5d65c577770104ab
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                                 IMAGE ID       CREATED         SIZE
xilinx-ubuntu-18.04.5-user   v2022.1                             3948232ade92   2 hours ago     2.69GB
ubuntu-iso                   18.04.5                             7ea851496147   5 months ago    670MB
```
