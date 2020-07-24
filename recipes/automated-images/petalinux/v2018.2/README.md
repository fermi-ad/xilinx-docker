[//]: # (Readme.md - Petalinux v2018.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> depends/
	-> petalinux-v2018.2-final-installer.run
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2018-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Petalinux Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Petalinux Installer.
	- Xilinx Petalinux Installer v2018.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2018.2-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/71201.html
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2018.2 and earlier
		- Download Link:
			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 16.04.3 image (one time)
- Execute the image generation script __*../../../base-images/ubuntu_16.04.3/build_image.sh*__

```bash
$ pushd ../../../base-images/ubuntu-16.04.3
$ ./build_image.sh 
Base Release Image [Good] ubuntu-base-16.04.3-base-amd64.tar.gz
sha256:fc6c834c4aefbe1f8ea515d2a1898a6ef6ce55d8517597d0beab1f2840eab41b
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.3              8ce789b819ee        Less than a second ago   120MB

$ popd
```

## Generate an Ubuntu 16.04.3 user image (one time)
- Execute the image generation script __*../../../user-images/v2018.2/ubuntu-16.04.3-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2018.2/ubuntu-16.04.3-user/
$ ./build_image.sh 
...
Removing intermediate container f96c895773d9
 ---> c63f60c67792
Successfully built c63f60c67792
Successfully tagged xilinx-ubuntu-16.04.3-user:v2018.2
...
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 22 19:52:15 EDT 2020
ENDED   :Wed Jul 22 19:56:45 EDT 2020
-----------------------------------

$ popd
```

## Build a v2018.2 Petalinux Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Removing intermediate container 789a44f0d100
 ---> e5cc7304feae
Successfully built e5cc7304feae
Successfully tagged xilinx-petalinux:v2018.2
...
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 24 09:38:52 EDT 2020
ENDED   :Fri Jul 24 09:52:03 EDT 2020
-----------------------------------
```

## Create a working container (running in daemon mode) based on the vitis image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Make sure you mount at least one host folder so the docker container can access the Petalinux installer
- Example: using `-v /srv/software/xilinx:/srv/software`
	- gives access to host files under `/srv/software/xilinx` in the Docker container
	- `/srv/software` is the mounted location inside of the Docker container
	- `/srv/software/xilinx/` is the location of the Xilinx installers, bsps, etc...
	- `/srv/software/licenses/` is the location of the Xilinx license files

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2018.2              e5cc7304feae        4 minutes ago       16.2GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        38 hours ago        1.62GB
ubuntu                           16.04.3              8ce789b819ee        47 hours ago        120MB
```

- For images with the MALI Binaries pre-included, the image is slightly larger
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-mali            v2018.2              8c44c9c17e68        About a minute ago   16.2GB
xilinx-ubuntu-16.04.3-user       v2018.2              c63f60c67792        38 hours ago        1.62GB
ubuntu                           16.04.3              8ce789b819ee        47 hours ago        120MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_v2018.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2018-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-petalinux:v2018.2 \
	/bin/bash
6a5094a64127b8b78802de04bc11f1046fbc1b1aed77756dc736048f2d0cd842
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
6a5094a64127        xilinx-petalinux:v2018.2   "/bin/bash"         9 seconds ago       Up 8 seconds                            xilinx_petalinux_v2018.2
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_v2018.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2018.2'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx/petalinux/v2018.2$
```

## Execute Petalinux Tools
- Verify petalinux tools can execute
```bash
xterm:
xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx/petalinux/v2018.2$ petalinux-create --help
petalinux-create             (c) 2005-2018 Xilinx, Inc.

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

Options for project:
  --template <TEMPLATE>                 zynqMP|zynq|microblaze
                                        user needs specify which template to use.
  -s|--source <SOURCE>                  specify a PetaLinux BSP as a project
                                        source.

Options for apps:
  --template <TEMPLATE>                 <c|c++|autoconf|install>
                                        c   : c user application(default)
                                        c++ : c++ user application
                                        autoconf: autoconf user application
                                        install: install data only
  -s, --source <SOURCE>                 valid source name format:
                                          *.tar.gz, *.tgz, *.tar.bz2, *.tar,
                                          *.zip, app source directory

Options for modules: (No specific options for modules)

EXAMPLES:

Create project from PetaLinux Project BSP:
  $ petalinux-create -t project -s <PATH_TO_PETALINUX_PROJECT_BSP>

Create project from template:
For microblaze project,
  $ petalinux-create -t project -n <PROJECT> --template microblaze
For zynq project,
  $ petalinux-create -t project -n <PROJECT> --template zynq
For zynqMP project,
  $ petalinux-create -t project -n <PROJECT> --template zynqMP


Create an app and enable it:
  $ petalinux-create -t apps -n myapp --enable
The application "myapp" will be created with c template in:
  <PROJECT>/project-spec/meta-user/recipes-apps/myapp


Create an module and enable it:
  $ petalinux-create -t modules -n mymodule --enable
The module "mymodule" will be created with template in:
  <PROJECT>/project-spec/meta-user/recipes-modules/mymodule

xilinx@xilinx_petalinux_v2018-2:/opt/Xilinx/petalinux/v2018.2$ 
```