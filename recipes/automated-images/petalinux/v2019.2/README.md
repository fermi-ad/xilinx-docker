[//]: # (Readme.md - Petalinux v2019.2 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> depends/
	-> petalinux-v2019.2-final-installer.run
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

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 18.04.2 image (one time)
- Execute the image generation script __*../../../base-images/ubuntu_18.04.2/build_image.sh*__

```bash
$ pushd ../../../base-images/ubuntu-18.04.2
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-18.04.2-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz -O depends/ubuntu-base-18.04.2-base-amd64.tar.gz
--2019-12-18 10:20:17--  http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 2001:67c:1360:8001::27, 2001:67c:1560:8001::1d, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 31858560 (30M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’

depends/ubuntu-base-18.04.2-base-amd64.tar.gz            100%[=================================================================================================================================>]  30.38M  18.9MB/s    in 1.6s    

2019-12-18 10:20:18 (18.9 MB/s) - ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’ saved [31858560/31858560]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.2-base-amd64.tar.gz ubuntu:18.04.2
sha256:1c767f5d46fef0b75f5a1ab0f971b79f5fe3343f90c2861842713c6be7cf2a46
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.2              1c767f5d46fe        Less than a second ago   88.3MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   88.3MB              0B (0%)
Containers          0                   0                   0B            	 	0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

$ popd
```

## Generate an Ubuntu 18.04.2 user image (one time)
- Execute the image generation script __*../../../user-images/v2019.2/ubuntu-18.04.2-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2019.2/ubuntu-18.04.2-user/
$ ./build_image.sh 
-----------------------------------
Checking for configurations...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------
Docker Build Context (Working)...
-----------------------------------
...
Removing intermediate container f0caed766af2
 ---> 5d774cff76ff
Successfully built 5d774cff76ff
Successfully tagged xilinx-ubuntu-18.04.2-user:v2019.2
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 14815
-----------------------------------
+ kill 14815
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 14815 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Mon Jul 6 15:58:02 EDT 2020
ENDED   :Mon Jul 6 16:03:28 EDT 2020
-----------------------------------

$ popd
```

## Build a v2019.2 Petalinux Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Removing intermediate container c6ceb46e50c9
 ---> 56f03e638b0e
Successfully built 56f03e638b0e
Successfully tagged xilinx-petalinux:v2019.2
...
-----------------------------------
Image Build Complete...
STARTED :Thu Jul 16 14:05:04 EDT 2020
ENDED   :Thu Jul 16 14:13:49 EDT 2020
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
xilinx-petalinux                 v2019.2              18b40e9c0faf        About a minute ago  18.4GB
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        21 hours ago        2.02GB
ubuntu                           18.04.2              c31ac5f5c1b0        8 days ago          88.3MB
```

- For images with the MALI Binaries pre-included, the image is slightly larger
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-with-mali       v2019.2              56f03e638b0e        11 minutes ago      18.6GB
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        21 hours ago        2.02GB
ubuntu                           18.04.2              c31ac5f5c1b0        8 days ago          88.3MB
```

#### Create a working container manually

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
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
552e6f31fc4d        xilinx-petalinux:v2019.2   "/bin/bash"         11 seconds ago      Up 10 seconds                           xilinx_petalinux_v2019.2
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
For versal project,
  $ petalinux-create -t project -n <PROJECT> --template versal


Create an app and enable it:
  $ petalinux-create -t apps -n myapp --enable
The application "myapp" will be created with c template in:
  <PROJECT>/project-spec/meta-user/recipes-apps/myapp


Create an module and enable it:
  $ petalinux-create -t modules -n mymodule --enable
The module "mymodule" will be created with template in:
  <PROJECT>/project-spec/meta-user/recipes-modules/mymodule
  
xilinx@xilinx_petalinux_v2019-2:/opt/Xilinx/petalinux/v2019.2$
```


