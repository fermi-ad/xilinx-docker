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

















< --- OLD README BELOW --- >







## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## To Generate a base Ubuntu 18.04.1 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_18.04.1/build_image.sh*__

```bash
$ pushd ../..//base-images/ubuntu-18.04.1
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-18.04.1-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz -O depends/ubuntu-base-18.04.1-base-amd64.tar.gz
--2019-06-22 13:34:23--  http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.1/release/ubuntu-base-18.04.1-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 2001:67c:1360:8001::27, 2001:67c:1360:8001::1d, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 30859938 (29M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-18.04.1-base-amd64.tar.gz’

depends/ubuntu-base-18.04.1-base 100%[========================================================>]  29.43M   270KB/s    in 1m 54s  

2019-06-22 13:36:18 (265 KB/s) - ‘depends/ubuntu-base-18.04.1-base-amd64.tar.gz’ saved [30859938/30859938]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-18.04.1-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.1-base-amd64.tar.gz ubuntu:18.04.1
sha256:4112b3ccf8569cf0e67fe5b99c011ab93a27dd42137ea26f88f070b52f8e15a8
+ docker image ls -a
REPOSITORY               TAG                 IMAGE ID            CREATED                  SIZE
ubuntu                   18.04.1             4112b3ccf856        Less than a second ago   83.5MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              12                  4                   123.5GB             87.35GB (70%)
Containers          4                   0                   743.1MB             743.1MB (100%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x
```


### Alternatively, Generate a base Ubuntu 16.04.5 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_16.04.5/build_image.sh*__


- For Windows Powershell, execute the image generation script __*..\..\base_images\ubuntu_16.04.3\build_image.ps1*__
	- Note: If it appears that the script has hung and nothing is happening, look at the top of the Powershell command line window to see if there is a status message like this (it should be downloading the base Ubuntu Image)

```powershell
powershell:
Writing web request
	Writing request stream... (Number of bytes written: 17218561)
```

```powershell
powershell:
PS X:\...\base-images\ubuntu_16.04.3> .\build_image.ps1
```

## Generate Petalinux Image Dependencies (one time)

### Execute the dependency generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_depends.sh
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
	-rw-r--r-- 1 xilinx xilinx 1554 Jul 11 17:24 _generated/configs/keyboard_settings.conf

```

- Copy the generated dependencies to the dependency folder

```bash
bash:
	$ cp _generated/configs/* configs/
	$ cp _generated/depends/* depends/
```

## Build a v2019.1 Petalinux Image (one time)

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
Removing intermediate container ad89f035e233
 ---> a8f0f7941a97
Successfully built a8f0f7941a97
Successfully tagged xilinx-petalinux:v2019.1
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 3496
-----------------------------------
-----------------------------------
Image Build Complete...
STARTED :Mon Jul 15 08:09:46 EDT 2019
ENDED   :Mon Jul 15 08:21:07 EDT 2019
-----------------------------------

```

## Create a working container (running in daemon mode) based on the petalinux image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux                            v2019.1             a8f0f7941a97        About an hour ago   23.9GB
ubuntu                                      18.04.1             4112b3ccf856        3 weeks ago         83.5MB


$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-petalinux:v2019.1 xilinx_petalinux_v2019.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux:v2019.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
access control disabled, clients can connect from any host
9a030adcf6d4f18ce1b011530602e8a1a899a4ec46f13abd3ddc5aa3f3192c51

$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
9a030adcf6d4        xilinx-petalinux:v2019.1   "/bin/bash"         5 seconds ago       Up 4 seconds                            xilinx_petalinux_v2019.1


 $ docker inspect xilinx_petalinux_v2019.1 | grep "MacAddress"            
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
$ docker exec -d xilinx_petalinux_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.1$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_petalinux_v2019.1
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx/petalinux/v2019.1$ xterm &
[1] 714
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx/petalinux/v2019.1$
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.1'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.1$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash:
bash:
xilinx@xilinx_petalinux_v2019.1:/opt/Xilinx/petalinux/v2019.1$ read escape sequence
[1]+  Done                    docker exec -d xilinx_petalinux_v2019.1 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
9a030adcf6d4        xilinx-petalinux:v2019.1   "/bin/bash"         3 minutes ago       Up 3 minutes                            xilinx_petalinux_v2019.1
```

# Backup and Sharing of Working Containers and Images
- Docker images and containers can be backed up to tar archive files
	- Similar to a Virtual Machine image created in VMWare or Virtualbox, you can store, share and later restore working containers from a tar archive
- A docker container is __*exported*__ to an archive file
- A docker image is __*saved*__ or __*exported*__ to an archive file
- A docker image that was __*saved*__ should be __*loaded*__ to restore the image from an archive
- A docker image or container that was __*exported*__ should be __*imported*__ to create a new image from an 
- The major differences between a __*save*__ and an __*export*__
	- A __*saved*__ image retains the complete layer history of the docker image and any configuration of that image (based on the as commit to the repository)
	- An __*exported*__ image or container retains only the state of the filesystem and therefore will start up logged in as the user root.
	- Loading an image backup with full history retains operational state of the loaded image (including what user should be logged in).
	- Importing an image or container backup does not retain operational state since the history is lost, so the __*run_image_x11_macaddr.sh*__ script provided in the tools folder of this repository sets the user to a non-root user when creating a container from an image to address one of these differences.


## Archive or Restore a Docker Container or Image
### Example: Backup the base working container's current state to a local archive file
- Create a backup image of a bare container with Vivado Tools installed and licensed using __*docker save*__
- If backing up an existing image and not a container, skip the next two steps and start with identifying the image in your repository to backup

- Stop the running container first
```bash
bash:
docker stop xilinx_petalinux_v2019.1 
xilinx_petalinux_v2019.1
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_petalinux_v2019.1 xilinx-petalinux-backup:v2019.1
sha256:46e93b7081ea955a8ec3285ef34c044bbb74560a9f8fb982dfaff35ce288067e
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux-backup                     v2019.1             46e93b7081ea        13 seconds ago      23.9GB
xilinx-petalinux                            v2019.1             a8f0f7941a97        2 hours ago         23.9GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-petalinux-v2019.1_image_backup_saved_02deadbeef91.tar xilinx-petalinux-backup:v2019.1
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xilinx-petalinux-v2019.1*
-rw------- 1 xilinx xilinx 24027749888 Jul 15 09:55 xlnx-petalinux-v2019.1_image_backup_saved_02deadbeef91.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-petalinux-backup:v2019.1 
Untagged: xilinx-petalinux-backup:v2019.1
Deleted: sha256:46e93b7081ea955a8ec3285ef34c044bbb74560a9f8fb982dfaff35ce288067e
Deleted: sha256:95652f746153da9f342dd030fc571da05ae5caabe79eaed097f64c1b0702caab
```

### Example: Restore a container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Petalinux Tools installed and licensed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working Vivado environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-petalinux-v2019.1_image_backup_saved_02deadbeef91.tar 
385957e36dda: Loading layer [==================================================>]  17.92kB/17.92kB
Loaded image: xilinx-petalinux-backup:v2019.1
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux-backup                     v2019.1             46e93b7081ea        6 minutes ago       23.9GB
xilinx-petalinux                            v2019.1             a8f0f7941a97        2 hours ago         23.9GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-petalinux-backup:v2019.1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
46e93b7081ea        7 minutes ago       /bin/bash                                       2.64kB              
<missing>           2 hours ago         |12 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.14MB              
<missing>           2 hours ago         |12 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   14.5GB              
<missing>           2 hours ago         |12 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.17MB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           2 hours ago         |10 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   7.67GB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_PETALINUX_AUTOIN…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           2 hours ago         |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   163MB               
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           2 hours ago         |8 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User@…   79B                 
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           2 hours ago         |6 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   1.14GB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           2 hours ago         |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   39.6MB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   39.5MB              
<missing>           2 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   277MB               
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           3 weeks ago                                                         83.5MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh  xilinx-petalinux-backup:v2019.1 xilinx_petalinux_backup_v2019.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux-backup:v2019.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_backup_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
access control disabled, clients can connect from any host
e8533e14af2afe6c739e9cd3beccf1d8a647a867a129f9c239d42ebbd404c035
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Petalinux installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-petalinux-v2019.1_container_backup_02deadbeef91.tar xilinx_petalinux_v2019.1
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-petalinux-v2019.1*
-rw------- 1 xilinx xilinx 15675235840 Jul 15 10:01 xlnx-petalinux-v2019.1_container_backup_02deadbeef91.tar
-rw------- 1 xilinx xilinx 24027749888 Jul 15 09:55 xlnx-petalinux-v2019.1_image_backup_saved_02deadbeef91.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Petalinunx Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-petalinux-v2019.1_container_backup_02deadbeef91.tar xilinx-petalinux-imported:v2019.1
sha256:14c352865d01d60d8736a3809ea6e3204e4d165699fd8f3759f71c324e35a328
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux-imported                   v2019.1             14c352865d01        37 seconds ago      15.6GB
xilinx-petalinux                            v2019.1             a8f0f7941a97        2 hours ago         23.9GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-petalinux-imported:v2019.1
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
14c352865d01        About a minute ago                       15.6GB              Imported from -               
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-petalinux-imported:v2019.1 xilinx_petalinux_imported_v2019.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux-imported:v2019.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_imported_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
access control disabled, clients can connect from any host
ecac78fb282ca723001f866ae29ebb6f666e6e2659f516391c7e23faf0788664
```

## Get started with a petalinux build (in the running container)

### Create a new project using a development board BSP (this example uses the ZCU106)
- Create the project on a shared folder outside of the container
```bash
bash:
xilinx@xlnx-petalinux-v2019.1:/opt/Xilinx/petalinux/v2019.1$ mkdir -p /srv/shared/petalinux/v2019.1/zcu106_example
xilinx@xlnx-petalinux-v2019.1:/opt/Xilinx/petalinux/v2019.1$ pushd /srv/shared/petalinux/v2019.1/zcu106_example/
xilinx@xlnx-petalinux-v2019.1:/srv/shared/petalinux/v2019.1/$ petalinux-create -t project -n projects/zcu106_example -s /srv/software/bsps/xilinx-zcu106-v2019.1-final.bsp
INFO: Create project: projects/zcu106_example
INFO: New project Successfully created in /srv/shared/petalinux/v2019.1/projects/zcu106_example
```

### Configure the Petalinux Build
```bash
bash:
xilinx@xlnx-petalinux-v2019.1:/srv/shared/petalinux/v2019.1/$ cd projects/zcu106_example
xilinx@xlnx-petalinux-v2019.1:/srv/shared/petalinux/v2019.1/projects/zcu106_example$ petalinux-config
[INFO] generating Kconfig for project
[INFO] menuconfig project
```

#### Configuration parameters (1)
- NOTE: SSTATE Mirror directory is located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - Petalinux sstate-mirror
    	- docker run argument: ```-v /srv/sstate-mirrors/sstate-rel-v2019.1/```
- Image Packaging Configuration -> tftpboot directory
	- /tftpboot/v2019.1/projects/zcu106_example
- Yocto Settings -> Parallel thread execution
	- BB_NUMBER_THREADS = 4
	- PARALLEL_MAKE = 4
- Yocto Settings -> Local sstate feeds settings
	- local sstate feeds url = /srv/sstate-mirrors/sstate-rel-v2019.1/aarch64

```bash
bash:
configuration written to /srv/shared/petalinux/v2019.1/projects/zcu106_example/project-spec/configs/config

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
xilinx@xilinx_petalinux_import_v2019.1:/srv/shared/petalinux/v2019.1/projects/zcu106_example$ 
```

#### Configuration parameters (2)
- NOTE: SSTATE Cache and Download Directories are located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - docker run argument: ```-v /srv/sstate-cache/```
    - Petalinux sstate-mirror
    	- ```/srv/sstate-cache/v2019.1/```
    - Yocto sstate-cache download location
    	- ```-v /srv/sstate-cache/downloads/```
- These configuration are optional
- In the container, edit the file ./build/conf/local.conf
```bash
bash:
xilinx@xilinx_petalinux_import_v2019.1:/srv/shared/petalinux/v2019.1/projects/zcu106_example$ vi build/conf/local.conf
```
- Add the following optional configuration parameters at the end of the file:
```bash
# Use a shared SSTATE Cache Location
SSTATE_DIR ?= "/srv/sstate-cache/v2019.1"

# Turn on build history (disabled explicitly in Petalinux
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT="1"

# Use a shared DOWNLOAD directory
DL_DIR ?= "/srv/sstate-cache/downloads"
```

### Configuire the Petalinux Rootfs and Kernel
```bash
bash:
xilinx@xlnx-petalinux-v2019.1:/opt/Xilinx/petalinux/v2019.1/projects/zcu106_example$ petalinux-config -c rootfs
...
xilinx@xlnx-petalinux-v2019.1:/opt/Xilinx/petalinux/v2019.1/projects/zcu106_example$ petalinux-config -c kernel
...
```

### View the bitbake tasks associated with the recipe
```bash
bash:
xilinx@xilinx_petalinux_import_v2019.1:/srv/shared/petalinux/v2019.1/projects/zcu106_example$ petalinux-build -x listtasks
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
NOTE: Successfully copied built images to tftp dir:  /tftpboot/v2019.1/projects/zcu106_example
[INFO] successfully built project
xilinx@xilinx_petalinux_import_v2019.1:/srv/shared/petalinux/v2019.1/projects/zcu106_example$ 
```
