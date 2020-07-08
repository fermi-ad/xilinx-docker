[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2020.1 Xilinx Tools)

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

# Install Petalinux

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.2-user       v2020.1              5d774cff76ff        16 hours ago        2.01GB
ubuntu                           18.04.2              76df73440f9c        12 days ago         88.3MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_install_v2020.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2020-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.2-user:v2020.1 \
	/bin/bash
4924fbeebe6f016b6e918d44a968fe5b5e89e42334a9fe2dc965a784d6d0c53f
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
dcf7eb55112b        xilinx-ubuntu-18.04.2-user:v2020.1   "/bin/bash"         15 seconds ago      Up 13 seconds                           xilinx_petalinux_install_v2020.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_install_v2020.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/$
```

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/$ ls -al /srv/software/petalinux/*v2020.1*
-rwxrwxr-x 1 xilinx xilinx 1315548907 Jun  5 18:52 /srv/software/petalinux/petalinux-v2020.1-final-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/$ sudo mkdir -p /opt/Xilinx/petalinux/v2020.1
xilinx@xilinx_petalinux_v2020-1:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer
- Specify the install directory using the `-d` option

```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/$ cd /opt/Xilinx/
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx$ /srv/software/petalinux/petalinux-v2020.1-final-installer.run --dir petalinux/v2020.1 --log petalinux_install.log
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
Do you accept Webtalk Terms and Conditions? [y/N] > y
Do you accept Third Party End User License Agreement? [y/N] > y
INFO: Installing PetaLinux...
INFO: Checking PetaLinux installer integrity...
INFO: Installing PetaLinux SDK to "/opt/Xilinx/petalinux/v2020.1/."
INFO: Installing buildtools in /opt/Xilinx/petalinux/v2020.1/./components/yocto/buildtools
INFO: PetaLinux SDK has been installed to /opt/Xilinx/petalinux/v2020.1/.
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx$ echo ". /opt/Xilinx/petalinux/v2020.1/settings.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the petalinux paths
```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx$ source /opt/Xilinx/petalinux/v2020.1/settings.sh
PetaLinux environment set to '/opt/Xilinx/petalinux/v2020.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2020.1 PetaLinux Tools Documentation Reference Guide" for its impact and solution
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx$ petalinux-util --webtalk off
INFO: Turn off webtalk feature!
```

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx$ Exit
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installer to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_petalinux_install_v2020.1 xilinx-petalinux:v2020.1
sha256:c3c0739fbc73d9d9deb4bd539921846f245b9b688d2769260c2018abc02fc13d
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2020.1              c3c0739fbc73        15 seconds ago      10.7GB
xilinx-ubuntu-18.04.2-user       v2020.1              5d774cff76ff        16 hours ago        2.01GB
ubuntu                           18.04.2              76df73440f9c        12 days ago         88.3MB
```
