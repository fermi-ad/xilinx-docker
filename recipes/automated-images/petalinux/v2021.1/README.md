[//]: # (Readme.md - Petalinux v2021.1 Build Environment)

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
	-> petalinux-v2021.1-final-installer.run
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Petalinux Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Petalinux Installer.
	- Xilinx Petalinux Installer v2021.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2021.1-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/76526.html
- Place the installer binary (or a link to it) in the ./depends folder

## MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries are now hosted on GITHUB and part of the BSP 
		- Reference Link:
			- https://github.com/Xilinx/mali-userspace-binaries

## Generate Petalinux Installer Links (one time)
- Create links to the installer/dependencies in the dependency folder

```bash
bash:
$ ln -s <path-to-offline-installer>/petalinux-v2021.1-final-installer.run depends/
$ ln -s <path-to-offline-installer>/mali-400-userspace.tar depends/
```

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 20.04.1 image (one time)
```bash
$ pushd ../../base-images/ubuntu-20.04.1/
$ sudo ./build_image.sh --iso
$ popd
```

## Generate an Ubuntu 20.04.1 user image 
- This contains all the dependencies for the v2021.1 Xilinx Tools

```bash
bash:
$ pushd ../../user-images/v2021.1/ubuntu-20.04.1-user
$ ./build_image.sh --iso
$ popd
```

## Build a v2021.1 Petalinux Image (one time)

### Execute the image build script
```bash
bash:
$ ./build_image.sh
	...
	-----------------------------------
	REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
	xilinx-petalinux   v2021.1   25e91af159cc   2 minutes ago   15.5GB
	-----------------------------------
	Image Build Complete...
	STARTED :Fri 02 Jul 2021 01:58:23 PM EDT
	ENDED   :Fri 02 Jul 2021 02:08:19 PM EDT
	-----------------------------------
```

# Create a container and verify tool installation

## More information about creating containers can be found here
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

### Create a working container manually
```bash
$ docker run \
	--name xilinx_petalinux_v2021.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2020-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-petalinux:v2021.1 \
	/bin/bash
d022aaa7277d727e73045d009e9659e9f94cd85f367aabdd4a5d446b0da257de
```

#### Verify the container was created and the MAC Address was set properly
```bash
$ docker ps -a
CONTAINER ID   IMAGE                                    COMMAND       CREATED          STATUS                   PORTS     NAMES
d022aaa7277d   xilinx-petalinux:v2021.1                 "/bin/bash"   16 seconds ago   Up 14 seconds                      xilinx_petalinux_v2021.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container

```bash
bash:
$ docker exec -id xilinx_petalinux_v2021.1 bash -c "xterm" &
```

- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script

```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2021.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2021.1 PetaLinux Tools Documentation Reference Guide" for its impact and solution
xilinx@xilinx_petalinux_v2020-2:/opt/Xilinx/petalinux/v2021.1$
```

## Execute Petalinux Tools
- Verify petalinux tools can execute

```bash
xterm:
xilinx@xilinx_petalinux_v2020-1:/opt/Xilinx/petalinux/v2021.1$ petalinux-create --help
	petalinux-create             (c) 2005-2021 Xilinx, Inc.

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
	Options:
	  -p, --project <PROJECT>               specify full path to a PetaLinux project
	                                        this option is NOT USED for PROJECT CREATION.
	                                        default is the working project.
	  --force                               force overwriting an existing component
	                                        directory.
	  -h, --help                            show function usage
	  --enable                              this option applies to all types except
	                                        project.
	                                        enable the created component
	  --srcuri                              this option is to specify the source files
	                                        from outside project.This will copy specified
	                                        files into recipe files directory and add to
	                                        SRC_URI variable in .bb file.
	                                        Specify the multiple files with space.
	  --tmpdir                              Specify the local drive path as TMPDIR location when creating
	                                        the project.
	                                        Default TMPDIR cannot be under NFS.By default,petalinux will
	                                        set the TMPDIR under /tmp when project is on NFS.
	                                        You can set your own local drive as TMPDIR PATH using --tmpdir option.

	Options for project:
	  --template <TEMPLATE>                 versal|zynqMP|zynq|microblaze
	                                        user needs specify which template to use.
	  -s|--source <SOURCE>                  specify a PetaLinux BSP as a project
	                                        source.

	Options for apps:
	  --template <TEMPLATE>                 <c|c++|autoconf|install>
	                                        c   : c user application(default)
	                                        c++ : c++ user application
	                                        autoconf: autoconf user application
	                                        install: install data only
	                                        fpgamanager    : Pack the .dtbo,.bin,shell.json and .xclbin files into rootfs, supports only for zynq,zynqmp.
	                                        fpgamanger_dtg : Extract the .xsa and pack the .dtbo,.bin,shell.json and .xclbin files into rootfs, supports only for zynq,zynqmp.
	  -s, --source <SOURCE>                 valid source name format:
	                                          *.tar.gz, *.tgz, *.tar.bz2, *.tar,
	                                          *.zip, app source directory

	Options for modules: (No specific options for modules)

	EXAMPLES:

	Create project from PetaLinux Project BSP:
	  $ petalinux-create -t project -s <PATH_TO_PETALINUX_PROJECT_BSP>

	Create project from PetaLinux Project BSP and specify the TMPDIR PATH:
	  $ petalinux-create -t project -s <PATH_TO_PETALINUX_PROJECT_BSP> --tmpdir <TMPDIR PATH>

	Create project from template and specify the TMPDIR PATH:
	  $ petalinux-create -t project -n <PROJECT> --template <TEMPLATE> --tmpdir <TMPDIR PATH>

	Create project from template:
	For microblaze project,
	  $ petalinux-create -t project -n <PROJECT> --template microblaze
	For zynq project,
	  $ petalinux-create -t project -n <PROJECT> --template zynq
	For zynqMP project,
	  $ petalinux-create -t project -n <PROJECT> --template zynqMP
	For versal project,
	  $ petalinux-create -t project -n <PROJECT> --template versal


	Create an app and enable it:
	  $ petalinux-create -t apps -n myapp --enable
	The application "myapp" will be created with c template in:
	  <PROJECT>/project-spec/meta-user/recipes-apps/myapp

	Create an app with remote sources:
	  $ petalinux-create -t apps -n myapp --enable --srcuri http://example.tar.gz
	  $ petalinux-create -t apps -n myapp --enable --srcuri git://example.git\;protocol=https
	  $ petalinux-create -t apps -n myapp --enable --srcuri https://example.tar.gz

	Create a FPGAmanager application to install .dtsi and .bit into rootfs(/lib/firmware/xilinx)
	  $ petalinux-create -t apps --template fpgamanager -n gpio --enable
	The application "gpio" will be created with the fpgamanager_custom class
	include to build .dtbo,.bin and shell.json files which will be installed on target.

	Create an app with local source files:
	  $ petalinux-create -t apps --template fpgamanager -n gpio --enable --srcuri \
	        "<path>/pl.dtsi <path>/system.bit <path>/shell.json"
	This will create "gpio" application with pl.dtsi,system.bit and shell.json added
	to SRC_URI and copied to files directory.

	Create a FPGAmanager_dtg application to extract the xsa and install .dtsi and .bit into rootfs(/lib/firmware/xilinx)
	  $ petalinux-create -t apps --template fpgamanager_dtg -n gpio --enable --srcuri "<path>/gpio.xsa <path>/shell.json"
	This will create "gpio" application included with fpgamanager_dtg class, \
	gpio.xsa and shell.json added to SRC_URI and copied to files directory.


	Create an module and enable it:
	  $ petalinux-create -t modules -n mymodule --enable
	The module "mymodule" will be created with template in:
	  <PROJECT>/project-spec/meta-user/recipes-modules/mymodule

	Create an module with source files:
	  $ petalinux-create -t modules -n mymodule --enable --srcuri "<path>/mymoudle.c <path>/Makefile"
```
