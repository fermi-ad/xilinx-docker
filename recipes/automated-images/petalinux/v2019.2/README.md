[//]: # (Readme.md - Petalinux v2019.2 Build Environment)

# References

## Additional Documentation

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> depends/
  -> petalinux-v2020.1-final-installer.run
  -> mali-400-userspace.tar
-> include/
  -> configuration.sh
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Petalinux Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Petalinux Installer.
	- Xilinx Petalinux Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2019.2-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/72950.html
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2019.1 and earlier (used with v2019.2)
		- Download Link:
			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
- Place the installer binary (or a link to it) in the ./depends folder

## Generate Petalinux Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/petalinux-v2019.2-final-installer.run depends/
$ ln -s <path-to-offline-installer>/mali-400-userspace.tar depends/
```

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 18.04.2 image (one time)
```bash
$ pushd ../../base-images/ubuntu-18.04.2/
$ sudo ./build_image.sh --iso
$ popd
```

## Generate an Ubuntu 18.04.2 user image 
- This contains all the dependencies for the v2020.1 Xilinx Tools

```bash
bash:
$ pushd ../../user-images/v2020.1/ubuntu-18.04.2-user
$ ./build_image.sh --iso
$ popd
```

## Build a v2019.2 Petalinux Image (one time)

### Execute the image build script
```bash
bash:
$ ./build_image.sh
  ...
  -----------------------------------
  REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
  xilinx-petalinux    v2019.2             caa44dc25d6e        About a minute ago   18.7GB
  -----------------------------------
  Image Build Complete...
  STARTED :Sun 22 Nov 2020 02:23:25 PM EST
  ENDED   :Sun 22 Nov 2020 02:36:55 PM EST
  -----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_v2019.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2019-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-petalinux:v2019.2 \
	/bin/bash
552e6f31fc4d0596765f56a8c983c997d9b8497c3cd2abe121e252c147dd052c
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container

```bash
bash:
$ docker exec -it xilinx_petalinux_v2019.2 bash -c "xterm" &
```

- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script

```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.2'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019-2:/opt/Xilinx/petalinux/v2019.2$ 
```

## Execute Petalinux Tools
- Verify petalinux tools can execute

```bash
xterm:
xilinx@xilinx_petalinux_v2019-2:/opt/Xilinx/petalinux/v2019.2$ petalinux-create --help
petalinux-create             (c) 2005-2019 Xilinx, Inc.

This command creates a new PetaLinux Project or component

Usage:
  petalinux-create [options] <-t|--type <TYPE> <-n|--name <COMPONENT_NAME>

Required:
  -t, --type <TYPE>                     Available type:
                                          * project : PetaLinux project
                                          * apps    : Linux user application
                                          * modules : Linux user module
  -n, --name <COMPONENT_NAME>           specify a name for the component or
                                        project. It is OPTIONAL to create a
                                        PROJECT. If you specify source BSP when
                                        you create a project, you are not
                                        required to specify the name.
...
Create an module and enable it:
  $ petalinux-create -t modules -n mymodule --enable
The module "mymodule" will be created with template in:
  <PROJECT>/project-spec/meta-user/recipes-modules/mymodule
  
xilinx@xilinx_petalinux_v2019-2:/opt/Xilinx/petalinux/v2019.2$
```


