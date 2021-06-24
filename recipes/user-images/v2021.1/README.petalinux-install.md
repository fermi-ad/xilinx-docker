[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2021.2 Xilinx Tools)

# Install Petalinux

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE
xilinx-ubuntu-20.04.1-user       v2021.1   e3b96ce9f445   3 hours ago    1.75GB
ubuntu-iso                       20.04.1   b22e81a44813   3 hours ago    267MB
ubuntu                           20.04.1   16d905ba1cbe   6 months ago   72.9MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_install_v2021.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2021.1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/install/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-20.04.1-user:v2021.1 \
	/bin/bash
8b7e03ff9bb8d7b74994d74b7d12be67d8b7b100a38e84230bee1d25795adb12
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                    COMMAND       CREATED          STATUS                    PORTS     NAMES
8b7e03ff9bb8   xilinx-ubuntu-20.04.1-user:v2021.1       "/bin/bash"   35 seconds ago   Up 32 seconds                       xilinx_petalinux_install_v2021.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_install_v2021.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/$
```

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/$ ls -al /srv/software/petalinux/*v2021.1*
-rw-rw-r-- 1 xilinx xilinx 2218825347 Jun 23 13:32 /srv/software/petalinux/petalinux-v2021.1-final-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/$ sudo mkdir -p /opt/Xilinx/petalinux/v2021.1
xilinx@xilinx_petalinux_v2021-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer
- Specify the install directory using the `-d` option

```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/$ cd /opt/Xilinx/
xilinx@xilinx_petalinux_v2021-1:/opt/Xilinx$ /srv/software/petalinux/petalinux-v2021.1-final-installer.run --dir petalinux/v2021.1 --log petalinux_install.log
INFO: Checking installation environment requirements...
INFO: Checking free disk space
INFO: Checking installed tools
environment: line 264: bc: command not found
environment: line 265: [: : integer expression expected
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
Do you accept Webtalk Terms and Conditions? [y/N] > y
Do you accept Third Party End User License Agreement? [y/N] > y
INFO: Installing PetaLinux...
INFO: Checking PetaLinux installer integrity...
INFO: Installing PetaLinux SDK to "/opt/Xilinx/petalinux/v2021.1/."
INFO: Installing buildtools in /opt/Xilinx/petalinux/v2021.1/./components/yocto/buildtools
INFO: Installing buildtools-extended in /opt/Xilinx/petalinux/v2021.1/./components/yocto/buildtools_extended
INFO: PetaLinux SDK has been installed to /opt/Xilinx/petalinux/v2021.1/
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/opt/Xilinx$ echo ". /opt/Xilinx/petalinux/v2021.1/settings.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the petalinux paths
```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/opt/Xilinx$ source /opt/Xilinx/petalinux/v2021.1/settings.sh
PetaLinux environment set to '/opt/Xilinx/petalinux/v2021.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2020.2 PetaLinux Tools Documentation Reference Guide" for its impact and solution
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/opt/Xilinx$ petalinux-util --webtalk off
INFO: Turn off webtalk feature!
```

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_petalinux_v2021-1:/opt/Xilinx$ exit
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installed to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_petalinux_install_v2021.1 xilinx-petalinux:v2021.1
sha256:ac3adff373febeee98b5cd653dd27794573377da2e405cea5d65c577770104ab
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG       IMAGE ID       CREATED          SIZE
xilinx-petalinux	             v2021.1   ac3adff373fe   39 seconds ago   14.8GB
xilinx-ubuntu-20.04.1-user       v2021.1   37f2b937e675   19 hours ago     2.09GB
ubuntu-iso                       20.04.1   b22e81a44813   23 hours ago     267MB
ubuntu                           20.04.1   16d905ba1cbe   6 months ago     72.9MB
```
