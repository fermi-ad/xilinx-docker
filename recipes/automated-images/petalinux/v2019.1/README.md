[//]: # (Readme.md - Petalinux v2019.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> depends/
	-> petalinux-v2019.1-final-installer.run
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
	- Xilinx Petalinux Installer v2019.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2019.1-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/72293.html
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2019.1 and earlier
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

## Generate a base Ubuntu 18.04.1 image (one time)
- Execute the image generation script __*../../../base-images/ubuntu_18.04.1/build_image.sh*__

```bash
$ pushd ../../../base-images/ubuntu-18.04.1
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-18.04.1-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz -O depends/ubuntu-base-18.04.1-base-amd64.tar.gz
--2020-07-17 20:37:33--  http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1560:8001::1d, 2001:67c:1360:8001::27, 2001:67c:1360:8001::28, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1560:8001::1d|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 30859938 (29M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-18.04.1-base-amd64.tar.gz’

depends/ubuntu-base-18.04.1-base-amd64.tar.gz       100%[===================================================================================================================>]  29.43M  15.7MB/s    in 1.9s    

2020-07-17 20:37:35 (15.7 MB/s) - ‘depends/ubuntu-base-18.04.1-base-amd64.tar.gz’ saved [30859938/30859938]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-18.04.1-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.1-base-amd64.tar.gz ubuntu:18.04.1
sha256:1f5eefc33d49b91eba954d0355917290c0e45d54f1e59ce0c918fade26662c89
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.1              1f5eefc33d49        Less than a second ago   83.5MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   83.5MB              0B (0%)
Containers          0                   0                   0B            	 	0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

$ popd
```

## Generate an Ubuntu 18.04.1 user image (one time)
- Execute the image generation script __*../../../user-images/v2019.1/ubuntu-18.04.1-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2019.1/ubuntu-18.04.1-user/
$ ./build_image.sh 
Removing intermediate container 344af33a95f3
 ---> 469af6a10c38
Successfully built 469af6a10c38
Successfully tagged xilinx-ubuntu-18.04.1-user:v2019.1
...
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 17 21:08:30 EDT 2020
ENDED   :Fri Jul 17 21:14:05 EDT 2020
-----------------------------------

$ popd
```

< --- UPDATE ME BELOW --- > 

## Build a v2019.1 Petalinux Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Removing intermediate container b68677175195
 ---> 746dfd69b82f
Successfully built 746dfd69b82f
Successfully tagged xilinx-petalinux:v2019.1
...
-----------------------------------
Image Build Complete...
STARTED :Sun Jul 19 16:14:58 EDT 2020
ENDED   :Sun Jul 19 16:22:45 EDT 2020
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
xilinx-petalinux                 v2019.1              ef556009517a        About a minute ago  16.5GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        43 hours ago        2.02GB
ubuntu                           18.04.1              1f5eefc33d49        44 hours ago        83.5MB

```

- For images with the MALI Binaries pre-included, the image is slightly larger
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-mali            v2019.1              ef556009517a        About a minute ago  16.7GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        43 hours ago        2.02GB
ubuntu                           18.04.1              1f5eefc33d49        44 hours ago        83.5MB
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_petalinux_v2019.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_petalinux_v2019-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-petalinux:v2019.1 \
	/bin/bash
de6932e1062c62e2ff64fdabb41a7d9d529af1b0f4470b25e6d9584c4c16adcf
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
de6932e1062c        xilinx-petalinux:v2019.2   "/bin/bash"         12 seconds ago      Up 10 seconds                           xilinx_petalinux_v2019.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_petalinux_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vitis and Vivado settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019-1:/opt/Xilinx/petalinux/v2019.1$
```

## Execute Petalinux Tools
- Verify petalinux tools can execute
```bash
xterm:
xilinx@xilinx_petalinux_v2019-1:/opt/Xilinx/petalinux/v2019.1$ petalinux-create --help
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

xilinx@xilinx_petalinux_v2019-1:/opt/Xilinx/petalinux/v2019.1$
```