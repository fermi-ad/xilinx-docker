[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2018.3 Xilinx Tools)

# Install Petalinux

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED              SIZE
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        2 hours ago          1.61GB
ubuntu                           16.04.4              3bd5992802b9        9 hours ago          112MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_install_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.4-user:v2018.3 \
	/bin/bash
480c528c7ae1911629c655e8f2796ff1e02fc6874e41711aa6dc943e98ab8b3e
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
480c528c7ae1        xilinx-ubuntu-16.04.4-user:v2018.3   "/bin/bash"         10 seconds ago      Up 9 seconds                            xilinx_petalinux_install_v2018.3
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_install_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/$
```

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/$ ls -al /srv/software/petalinux/*v2018.3*
-rwxrwxr-x 1 xilinx xilinx 7289606083 Dec 19  2018 /srv/software/petalinux/petalinux-v2018.3-final-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/$ sudo mkdir -p /opt/Xilinx/petalinux/v2018.3
xilinx@xilinx_petalinux_v2018-3:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer

```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/$ cd /opt/Xilinx/
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx$ /srv/software/petalinux/petalinux-v2018.3-final-installer.run --log petalinux_install.log ./petalinux/v2018.3
INFO: Checking installation environment requirements...
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
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
INFO: Installing PetaLinux SDK to "./petalinux/v2018.3/."
INFO: Installing aarch64 Yocto SDK to "./petalinux/v2018.3/./components/yocto/source/aarch64"...
INFO: Installing arm Yocto SDK to "./petalinux/v2018.3/./components/yocto/source/arm"...
INFO: Installing microblaze_full Yocto SDK to "./petalinux/v2018.3/./components/yocto/source/microblaze_full"...
INFO: Installing microblaze_lite Yocto SDK to "./petalinux/v2018.3/./components/yocto/source/microblaze_lite"...
INFO: PetaLinux SDK has been installed to ./petalinux/v2018.3/.
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx$ echo ". /opt/Xilinx/petalinux/v2018.3/settings.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the petalinux paths
```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx$ source /opt/Xilinx/petalinux/v2018.3/settings.sh
PetaLinux environment set to '/opt/Xilinx/petalinux/v2018.3'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx$ petalinux-util --webtalk off
INFO: Turn off webtalk feature!
```

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx$ exit
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installed to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_petalinux_install_v2018.3 xilinx-petalinux:v2018.3
sha256:0f9b10c24a20e1be77d075164d92ae194fa39f35540147bb0ae19cde3f7a488f
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2018.3              0f9b10c24a20        2 minutes ago       15.9GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        18 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        25 hours ago        112MB
```
