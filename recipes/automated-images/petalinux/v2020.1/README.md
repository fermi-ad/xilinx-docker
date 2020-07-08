[//]: # (Readme.md - Petalinux v2020.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> configs/
	-> keyboard_settings.conf
	-> XTerm
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
	- http://www.xilinx.com/support/download/2020-1/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Petalinux Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Petalinux Installer.
	- Xilinx Petalinux Installer v2020.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2020.1-final-installer.run
		- Release Notes;
			- https://www.xilinx.com/support/answers/73686.html
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2019.1 and earlier (used with v2020.1)
		- Download Link:
			- https://www.xilinx.com/products/design-tools/embedded-software/petalinux-sdk/arm-mali-400-software-download.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## To Generate a base Ubuntu 18.04.2 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_18.04.2/build_image.sh*__

```bash
$ ./build_image.sh 
Base Release Image [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.2-base-amd64.tar.gz ubuntu:18.04.2
sha256:76df73440f9c444f3397d23ad0f33339337c9061dfe2d4a8f52378e3704da71d
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.2              76df73440f9c        Less than a second ago   88.3MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   88.3MB              0B (0%)
Containers          0                   0                   0B                  0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

```

## Generate Petalinux Image Dependencies (one time)

### Execute the dependency generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_depends.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
-----------------------------------

...

+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Dependency Generation Complete
-----------------------------------
STARTED :Wed Jun 24 10:22:32 EDT 2020
ENDED   :Wed Jun 24 10:23:44 EDT 2020
-----------------------------------
DOCKER_FILE_NAME=Dockerfile
DOCKER_FILE_STAGE=base_os_petalinux_v2020.1
DOCKER_IMAGE=dependency_generation:v2020.1
DOCKER_CONTAINER_NAME=build_petalinux_depends_v2020.1
-----------------------------------
Dependencies Generated:
-----------------------------------
-rw-r--r-- 1 rjmoss rjmoss 1554 Jun 24 10:23 _generated/configs/keyboard_settings.conf
-----------------------------------
```
- Follow the build process in the terminal (manual interaction required)
- Keyboard configuration
	- Select a keyboard model: ```Generic 105-key (Intl) PC``` is the default
	- Select a country of origin for the keyboard: ```English (US)``` is the default
	- Select a keyboard layout: ```English (US)``` is the default
	- Select an AltGr function: ```The default for the keyboard layout``` is the default
	- Select a compose key: ```No compose key``` is the default
- Review the generated dependencies

```bash
bash:
	-rw-r--r-- 1 xilinx xilinx 1554 Jun 24 10:23 _generated/configs/keyboard_settings.conf
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
	$ cp _generated/configs/* configs/
	$ cp _generated/depends/* depends/
```

## Build a v2020.1 Petalinux Image (one time)

### Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__
- For Windows Hosts:
	- Modify build options in the file __*./include/configuration.ps1*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh
...
Removing intermediate container 2db13ab38695
 ---> 921da24fd087
Successfully built 921da24fd087
Successfully tagged xilinx-petalinux:v2020.1
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 29032
-----------------------------------
+ kill 29032
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 189: 29032 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Fri Nov 15 10:13:10 EST 2019
ENDED   :Fri Nov 15 10:42:41 EST 2019
-----------------------------------
```

## Create a working container (running in daemon mode) based on the petalinux image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux                 v2020.1              46f76f9e5d3d        18 hours ago        11.8GB
ubuntu                           18.04.2              76df73440f9c        25 hours ago        88.3MB

$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-petalinux:v2020.1 xilinx_petalinux_v2020.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux:v2020.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_v2020.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
cf173a76efa9fe230071f1143ccfd5d1a2c3c9a9832cb533c2e505f5d88b4f12

$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
cf173a76efa9        xilinx-petalinux:v2020.1   "/bin/bash"         19 seconds ago      Up 17 seconds                           xilinx_petalinux_v2020.1


$ docker inspect xilinx_petalinux_v2020.1 | grep "MacAddress"            
 	"MacAddress": "02:de:ad:be:ef:91",
    "MacAddress": "02:de:ad:be:ef:91",
    	"MacAddress": "02:de:ad:be:ef:91"
```

## Connect to the running container
- There are two common ways to interact with the container
	- use __*docker attach*__ to use the container interactively with a shell session
		- This method was used above to verify that the container was running
	- use __*docker exec*__ to execute commands in the container from the host OS command line

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -d xilinx_petalinux_v2020.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2020.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2020.1 PetaLinux Tools Documentation Reference Guide" for its impact and solution
xilinx@xilinx_petalinux_v2020:/opt/Xilinx/petalinux/v2020.1
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_petalinux_v2020.1
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx/petalinux/v2020.1$ xterm &
[1] 714
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx/petalinux/v2020.1$
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2020.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2020.1 PetaLinux Tools Documentation Reference Guide" for its impact and solution
xilinx@xilinx_petalinux_v2020:/opt/Xilinx/petalinux/v2020.1
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash:
bash:
xilinx@xilinx_petalinux_v2020.1:/opt/Xilinx/petalinux/v2020.1$ read escape sequence
[1]+  Done                    docker exec -d xilinx_petalinux_v2020.1 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
cf173a76efa9        xilinx-petalinux:v2020.1   "/bin/bash"         2 minutes ago       Up 2 minutes                            xilinx_petalinux_v2020.1
```

# Backup and Sharing of Working Containers and Images
- See common example documentation for [Backup and Sharing of Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)

## Get started with a petalinux build (in the running container)

### Create a new project using a development board BSP (this example uses the ZCU106)
- Create the project on a shared folder outside of the container
```bash
bash:
xilinx@xlnx-petalinux-v2020.1:/opt/Xilinx/petalinux/v2020.1$ mkdir -p /srv/shared/petalinux/v2020.1/zcu106_example
xilinx@xlnx-petalinux-v2020.1:/opt/Xilinx/petalinux/v2020.1$ pushd /srv/shared/petalinux/v2020.1/zcu106_example/
xilinx@xlnx-petalinux-v2020.1:/srv/shared/petalinux/v2020.1/$ petalinux-create -t project -n projects/zcu106_example -s /srv/software/bsps/xilinx-zcu106-v2020.1-final.bsp
INFO: Create project: projects/zcu106_example
INFO: New project Successfully created in /srv/shared/petalinux/v2020.1/projects/zcu106_example
```

### Configure the Petalinux Build
```bash
bash:
xilinx@xlnx-petalinux-v2020.1:/srv/shared/petalinux/v2020.1/$ cd projects/zcu106_example
xilinx@xlnx-petalinux-v2020.1:/srv/shared/petalinux/v2020.1/projects/zcu106_example$ petalinux-config
[INFO] generating Kconfig for project
[INFO] menuconfig project
```

#### Configuration parameters (1)
- NOTE: SSTATE Mirror directory is located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - Petalinux sstate-mirror
    	- docker run argument: ```-v /srv/sstate-mirrors/sstate-rel-v2020.1/```
- Image Packaging Configuration -> tftpboot directory
	- /tftpboot/v2020.1/projects/zcu106_example
- Yocto Settings -> Parallel thread execution
	- BB_NUMBER_THREADS = 4
	- PARALLEL_MAKE = 4
- Yocto Settings -> Local sstate feeds settings
	- local sstate feeds url = /srv/sstate-mirrors/sstate-rel-v2020.1/aarch64

```bash
bash:
configuration written to /srv/shared/petalinux/v2020.1/projects/zcu106_example/project-spec/configs/config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

[INFO] sourcing bitbake
[INFO] generating plnxtool conf
[INFO] generating meta-plnx-generated layer
[INFO] generating bbappends for project . This may take time ! 
[INFO] generating u-boot configuration files
[INFO] generating kernel configuration files
[INFO] generating kconfig for Rootfs
[INFO] oldconfig rootfs
[INFO] generating petalinux-user-image.bb
[INFO] successfully configured project
xilinx@xilinx_petalinux_import_v2020.1:/srv/shared/petalinux/v2020.1/projects/zcu106_example$ 
```

#### Configuration parameters (2)
- NOTE: SSTATE Cache and Download Directories are located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - docker run argument: ```-v /srv/sstate-cache/```
    - Petalinux sstate-mirror
    	- ```/srv/sstate-cache/v2020.1/```
    - Yocto sstate-cache download location
    	- ```-v /srv/sstate-cache/downloads/```
- These configuration are optional
- In the container, edit the file ./build/conf/local.conf
```bash
bash:
xilinx@xilinx_petalinux_import_v2020.1:/srv/shared/petalinux/v2020.1/projects/zcu106_example$ vi build/conf/local.conf
```
- Add the following optional configuration parameters at the end of the file:
```bash
# Use a shared SSTATE Cache Location
SSTATE_DIR ?= "/srv/sstate-cache/v2020.1"

# Turn on build history (disabled explicitly in Petalinux
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT="1"

# Use a shared DOWNLOAD directory
DL_DIR ?= "/srv/sstate-cache/downloads"
```

### Configuire the Petalinux Rootfs and Kernel
```bash
bash:
xilinx@xlnx-petalinux-v2020.1:/opt/Xilinx/petalinux/v2020.1/projects/zcu106_example$ petalinux-config -c rootfs
...
xilinx@xlnx-petalinux-v2020.1:/opt/Xilinx/petalinux/v2020.1/projects/zcu106_example$ petalinux-config -c kernel
...
```

### View the bitbake tasks associated with the recipe
```bash
bash:
xilinx@xilinx_petalinux_import_v2020.1:/srv/shared/petalinux/v2020.1/projects/zcu106_example$ petalinux-build -x listtasks
[INFO] building project
[INFO] sourcing bitbake
INFO: bitbake petalinux-user-image -c listtasks
Loading cache: 100% |#########################################################################################################################################################################################################| Time: 0:00:01
Loaded 3460 entries from dependency cache.
Parsing recipes: 100% |#######################################################################################################################################################################################################| Time: 0:00:05
Parsing of 2569 .bb files complete (2535 cached, 34 parsed). 3461 targets, 137 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies
Initialising tasks: 100% |####################################################################################################################################################################################################| Time: 0:00:13
NOTE: Executing RunQueue Tasks
do_build                       Default task for a recipe - depends on all other normal tasks required to 'build' a recipe
do_build_without_rm_work       
do_checkuri                    Validates the SRC_URI value
do_checkuriall                 Validates the SRC_URI value for all recipes required to build a target
do_clean                       Removes all output files for a target
do_cleanall                    Removes all output files, shared state cache, and downloaded source files for a target
do_cleansstate                 Removes all output files and shared state cache for a target
do_compile                     Compiles the source in the compilation directory
do_configure                   Configures the source by enabling and disabling any build-time and configuration options for the software being built
do_devpyshell                  Starts an interactive Python shell for development/debugging
do_devshell                    Starts a shell with the environment set up for development/debugging
do_fetch                       Fetches the source code
do_fetchall                    Fetches all remote sources required to build a target
do_image                       
do_image_complete              
do_image_complete_setscene      (setscene version)
do_image_cpio                  
do_image_ext3                  
do_image_ext4                  
do_image_jffs2                 
do_image_qa                    
do_image_qa_setscene            (setscene version)
do_image_tar                   
do_install                     Copies files from the compilation directory to a holding area
do_listtasks                   Lists all defined tasks for a target
do_package                     Analyzes the content of the holding area and splits it into subsets based on available packages and files
do_package_qa_setscene         Runs QA checks on packaged files (setscene version)
do_package_setscene            Analyzes the content of the holding area and splits it into subsets based on available packages and files (setscene version)
do_package_write_rpm           Creates the actual RPM packages and places them in the Package Feed area
do_package_write_rpm_setscene  Creates the actual RPM packages and places them in the Package Feed area (setscene version)
do_packagedata                 Creates package metadata used by the build system to generate the final packages
do_packagedata_setscene        Creates package metadata used by the build system to generate the final packages (setscene version)
do_patch                       Locates patch files and applies them to the source code
do_populate_lic                Writes license information for the recipe that is collected later when the image is constructed
do_populate_lic_setscene       Writes license information for the recipe that is collected later when the image is constructed (setscene version)
do_populate_sdk                Creates the file and directory structure for an installable SDK
do_populate_sdk_ext            
do_populate_sysroot_setscene   Copies a subset of files installed by do_install into the sysroot in order to make them available to other recipes (setscene version)
do_prepare_recipe_sysroot      
do_rm_work                     Removes work files after the build system has finished with them
do_rm_work_all                 Top-level task for removing work files after the build system has finished with them
do_rootfs                      Creates the root filesystem (file and directory structure) for an image
do_rootfs_wicenv               
do_sdk_depends                 
do_unpack                      Unpacks the source code into a working directory
NOTE: Tasks Summary: Attempted 1 tasks of which 0 didn't need to be rerun and all succeeded.
INFO: Copying Images from deploy to images
INFO: Creating images/linux directory
NOTE: Successfully copied built images to tftp dir:  /tftpboot/v2020.1/projects/zcu106_example
[INFO] successfully built project
xilinx@xilinx_petalinux_import_v2020.1:/srv/shared/petalinux/v2020.1/projects/zcu106_example$ 
```
