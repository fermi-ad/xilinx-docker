[//]: # (Readme.petalinux-install.md - Install Petalinux on a Base Ubuntu User Image for v2018.2 Xilinx Tools)

# Install Petalinux

## Create a working container (running in daemon mode) based on the petalinux image

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED              SIZE
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        About a minute ago   1.62GB
ubuntu                           16.04.3              8ce789b819ee        9 hours ago          120MB
```

### Create a working petalinux install container
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: `-v /srv/software/xilinx:/srv/software`
	- `/srv/software/xilinx/` is the Host location of the installer binaries
	- `/srv/software` is the mounted location inside of the Docker container

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_install_v2018.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2018-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.3-user:v2018.2 \
	/bin/bash
d7d5956842a1e2d55c966a32b739e88a5556ef54a8c82bde0584d3a275338000
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
d7d5956842a1        xilinx-ubuntu-16.04.3-user:v2018.2   "/bin/bash"         26 seconds ago      Up 25 seconds                           xilinx_petalinux_install_v2018.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_install_v2018.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/$
```

## Install Petalinux

### Locate the installer on the mounted host drive
```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/$ ls -al /srv/software/petalinux/*v2018.2*
-rwxrwxr-x 1 xilinx xilinx 6599854386 Jun 19  2018 /srv/software/petalinux/petalinux-v2018.2-final-installer.run
```

### Create an installation folder and change permissions/ownership

```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/$ sudo mkdir -p /opt/Xilinx/petalinux/v2018.2
xilinx@xilinx_petalinux_v2018-2:/$ sudo chown -hR xilinx:xilinx /opt
```

### Execute the installer

```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/$ cd /opt/Xilinx/
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx$ /srv/software/petalinux/petalinux-v2018.2-final-installer.run --log petalinux_install.log ./petalinux/v2018.2
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
INFO: Checking installation environment requirements...
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
INFO: Installing PetaLinux...
INFO: Checking PetaLinux installer integrity...
INFO: Installing PetaLinux SDK to "./petalinux/v2018.2/."
................................................................................................................................................................................................................................................................................INFO: Installing aarch64 Yocto SDK to "./petalinux/v2018.2/./components/yocto/source/aarch64"...
PetaLinux Extensible SDK installer version 2018.2
=================================================
You are about to install the SDK to "/opt/Xilinx/petalinux/v2018.2/components/yocto/source/aarch64". Proceed[Y/n]? Y
Extracting SDK................................done
Setting it up...
Extracting buildtools...
done
SDK has been successfully set up and is ready to be used.
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /opt/Xilinx/petalinux/v2018.2/components/yocto/source/aarch64/environment-setup-aarch64-xilinx-linux
INFO: Installing arm Yocto SDK to "./petalinux/v2018.2/./components/yocto/source/arm"...
PetaLinux Extensible SDK installer version 2018.2
=================================================
You are about to install the SDK to "/opt/Xilinx/petalinux/v2018.2/components/yocto/source/arm". Proceed[Y/n]? Y
Extracting SDK..............................done
Setting it up...
Extracting buildtools...
done
SDK has been successfully set up and is ready to be used.
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /opt/Xilinx/petalinux/v2018.2/components/yocto/source/arm/environment-setup-cortexa9hf-neon-xilinx-linux-gnueabi
INFO: Installing microblaze_full Yocto SDK to "./petalinux/v2018.2/./components/yocto/source/microblaze_full"...
PetaLinux Extensible SDK installer version 2018.2
=================================================
You are about to install the SDK to "/opt/Xilinx/petalinux/v2018.2/components/yocto/source/microblaze_full". Proceed[Y/n]? Y
Extracting SDK.............................done
Setting it up...
Extracting buildtools...
done
SDK has been successfully set up and is ready to be used.
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /opt/Xilinx/petalinux/v2018.2/components/yocto/source/microblaze_full/environment-setup-microblazeel-v10.0-bs-cmp-re-mh-div-xilinx-linux
INFO: Installing microblaze_lite Yocto SDK to "./petalinux/v2018.2/./components/yocto/source/microblaze_lite"...
PetaLinux Extensible SDK installer version 2018.2
=================================================
You are about to install the SDK to "/opt/Xilinx/petalinux/v2018.2/components/yocto/source/microblaze_lite". Proceed[Y/n]? Y
Extracting SDK.............................done
Setting it up...
Extracting buildtools...
done
SDK has been successfully set up and is ready to be used.
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /opt/Xilinx/petalinux/v2018.2/components/yocto/source/microblaze_lite/environment-setup-microblazeel-v10.0-bs-cmp-re-ml-xilinx-linux
INFO: PetaLinux SDK has been installed to ./petalinux/v2018.2/.
```

## Set petalinux script to execute for new shell sessions
- Specify this in the `.bashrc` file

```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx$ echo ". /opt/Xilinx/petalinux/v2018.2/settings.sh" > ~/.bashrc
```

## Turn off webtalk

### Initialize the petalinux paths
```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx$ source /opt/Xilinx/petalinux/v2018.2/settings.sh
PetaLinux environment set to '/opt/Xilinx/petalinux/v2018.2'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
```

### Disable webtalk
```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx$ petalinux-util --webtalk off
INFO: Turn off webtalk feature!
```

## Exit the Xterm session
- The Xterm window should close

```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx$ exit
```

# Create a Petalinux Docker Image in your local repository

Save a copy of the current working container as a new image in your local Docker repository.

## Commit the container with Petalinux installed to your repository 
- This creates a new `Docker Image` with Petalinux installed
- This may take a short time while the changes are committed
```bash
$ docker commit xilinx_petalinux_install_v2018.2 xilinx-petalinux:v2018.2
sha256:513adb4fb32b625e906b6c83e3544bdaee304653633fd3442e87843165489542
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2018.2              513adb4fb32b        33 seconds ago      16.2GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        16 hours ago        1.62GB
ubuntu                           16.04.3              8ce789b819ee        25 hours ago        120MB
```
