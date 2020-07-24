[//]: # (Readme.md - Petalinux v2018.3 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> depends/
	-> petalinux-v2018.3-final-installer.run
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2018-3/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Petalinux Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Petalinux Installer.
	- Xilinx Petalinux Installer v2018.3
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2018.3-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/71653.html
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2018.3 and earlier
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

## Generate a base Ubuntu 16.04.4 image (one time)
- Execute the image generation script __*../../../base-images/ubuntu_16.04.4/build_image.sh*__

```bash
$ pushd ../../../base-images/ubuntu-16.04.4
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-16.04.4-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.4/release/ubuntu-base-16.04.4-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.4/release/ubuntu-base-16.04.4-base-amd64.tar.gz -O depends/ubuntu-base-16.04.4-base-amd64.tar.gz
--2020-07-22 10:49:26--  http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.4/release/ubuntu-base-16.04.4-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 2001:67c:1360:8001::27, 2001:67c:1560:8001::1d, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 42145011 (40M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-16.04.4-base-amd64.tar.gz’

depends/ubuntu-base-16.04.4-base-amd64.tar.gz 100%[===============================================================================================>]  40.19M  14.0MB/s    in 2.9s    

2020-07-22 10:49:29 (14.0 MB/s) - ‘depends/ubuntu-base-16.04.4-base-amd64.tar.gz’ saved [42145011/42145011]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-16.04.4-base-amd64.tar.gz
+ docker import depends/ubuntu-base-16.04.4-base-amd64.tar.gz ubuntu:16.04.4
sha256:3bd5992802b9074965bc53c89729792526bbe75e89f3a0aae71b97af52af68e7
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.4              3bd5992802b9        Less than a second ago   112MB

$ popd
```

## Generate an Ubuntu 16.04.4 user image (one time)
- Execute the image generation script __*../../../user-images/v2018.3/ubuntu-16.04.4-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2018.3/ubuntu-16.04.4-user/
$ ./build_image.sh 
...
Removing intermediate container 662dae904442
 ---> 3dfc6437d7c9
Successfully built 3dfc6437d7c9
Successfully tagged xilinx-ubuntu-16.04.4-user:v2018.3
...
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 22 17:32:15 EDT 2020
ENDED   :Wed Jul 22 17:36:40 EDT 2020
-----------------------------------

$ popd
```

## Build a v2018.3 Petalinux Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Removing intermediate container 337a23581cba
 ---> 8fa273bd7bb1
Successfully built 8fa273bd7bb1
Successfully tagged xilinx-petalinux:v2018.3
...
-----------------------------------
Image Build Complete...
STARTED :Thu Jul 23 14:21:33 EDT 2020
ENDED   :Thu Jul 23 14:32:06 EDT 2020
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
xilinx-petalinux                 v2018.3              8fa273bd7bb1        19 hours ago        15.9GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        39 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        46 hours ago        112MB
```

- For images with the MALI Binaries pre-included, the image is slightly larger
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2018.3              6283c5cc862a        About a minute ago   16GB
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        39 hours ago        1.61GB
ubuntu                           16.04.4              3bd5992802b9        46 hours ago        112MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-petalinux:v2018.3 \
	/bin/bash
6a5094a64127b8b78802de04bc11f1046fbc1b1aed77756dc736048f2d0cd842
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
6a5094a64127        xilinx-petalinux:v2018.3   "/bin/bash"         9 seconds ago       Up 8 seconds                            xilinx_petalinux_v2018.3
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2018.3'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx/petalinux/v2018.3$
```

## Execute Petalinux Tools
- Verify petalinux tools can execute
```bash
xterm:
xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx/petalinux/v2018.3$ petalinux-create --help
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

xilinx@xilinx_petalinux_v2018-3:/opt/Xilinx/petalinux/v2018.3$ 
```