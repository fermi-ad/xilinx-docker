[//]: # (README.md - XSDK v2019.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.s
-> generate_depends.sh
-> Dockerfile
-> configs/
   -> keyboard_settings.conf
   -> xsdk_config_xsdk_full.config 
   -> XTerm
-> depends/
   -> Xilinx_SDK_2019.1_1207_2324_Lin64.bin
   -> (Xilinx_XSDK_2019.1_1207_2324_Lin64.tar.gz)
-> include/
   -> configuration.sh
```

# Quickstart
## Download Xilinx SDK Web Installer

Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.

## Download the v2019.1 Xilinx SDK Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx SDK v2019.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2019.1_0524_1430_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2019-1.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## Generate a base Ubuntu 18.04.1 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_18.04.1/scripts/build_image.sh*__

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

- For Windows Powershell, execute the image generation script __*..\..\base_images\ubuntu_18.04.1\build_image.ps1*__
	- Note: If it appears that the script has hung and nothing is happening, look at the top of the Powershell command line window to see if there is a status message like this (it should be downloading the base Ubuntu Image)

```powershell
powershell:
Writing web request
	Writing request stream... (Number of bytes written: 17218561)
```

```powershell
powershell:
PS X:\...\base-images\ubuntu-18.04.1> .\build_image.ps1
```

## Generate Xilinx SDK Image Dependencies (one time)

### Execute the dependency generation script

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
- Xilinx SDK batch mode configuration (generate)
	- Select Xilinx Software Development Kit (XSDK): option ```1```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```InstallOptions=Enable WebTalk for SDK to send usage statistics to Xilinx:0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=0```
	- Save with ```:wq```
- Xilinx SDK installer (download only)
	- This should launch an X11-based Xilinx SDK Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Full Image (Install Separately)```
		- Use the defaults:
			- download directory: ```/opt/Xilinx/Downloads/2019.1```
			- platform selection: ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/2019.1```
		- Disk Space Required:
			- ```Download Size: 1.42 GB```
			- ```Disk Space Required: 1.42 GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```
- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1554 Jul 24 10:40 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1351 Jul 24 10:43 _generated/configs/xsdk_config_xsdk_full.config
-rw-r--r-- 1 xilinx xilinx 1643275415 Jul 24 10:49 _generated/depends/Xilinx_SDK_2019.1_0524_1430_Lin64.tar.gz
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2019.1 Xilinx SDK Image (one time)

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
Removing intermediate container d1e504d44536
 ---> 6c9b7bee1673
Successfully built 6c9b7bee1673
Successfully tagged xilinx-xsdk:v2019.1
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 14845
-----------------------------------
./build_image.sh: line 185: 14845 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 24 11:02:35 EDT 2019
ENDED   :Wed Jul 24 11:08:22 EDT 2019
-----------------------------------

```

## Create a working container (running in daemon mode) based on the Xilinx SDK image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk              v2019.1             6c9b7bee1673        About an hour ago   12GB
ubuntu                   18.04.1             4112b3ccf856        4 weeks ago         83.5MB


$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk:v2019.1 xilinx_xsdk_v2019.1 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk:v2019.1
DOCKER_CONTAINER_NAME: xilinx_xsdk_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
8722544d8da714b8eefac317be503218225d02a874f69973e0ad71cf1ca8479b

$ docker ps -a
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS                           PORTS               NAMES
8722544d8da7        xilinx-xsdk:v2019.1              "/bin/bash"              18 seconds ago      Up 16 seconds                                        xilinx_xsdk_v2019.1

$ docker inspect xilinx_xsdk_v2019.1 | grep "MacAddress"
            "MacAddress": "02:de:ad:be:ef:93",
            "MacAddress": "02:de:ad:be:ef:93",
                    "MacAddress": "02:de:ad:be:ef:93",
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
$ docker exec -d xilinx_xsdk_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell ready to use the Xilinx SDK
```bash
xterm:
xilinx@xilinx_xsdk_v2019:/opt/Xilinx$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_xsdk_v2019.1
xilinx@xilinx_xsdk_v2019:/opt/Xilinx$ xterm &
[1] 146
xilinx@xilinx_xsdk_v2019:/opt/Xilinx$ 
```
- This launches an X-windows terminal shell for access to the container
```bash
xterm:
xilinx@xilinx_xsdk_v2019:/opt/Xilinx$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash
bash:
xilinx@xilinx_xsdk_v2019:/opt/Xilinx$ read escape sequence
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS                           PORTS               NAMES
8722544d8da7        xilinx-xsdk:v2019.1              "/bin/bash"              9 minutes ago      Up 16 minutes                                        xilinx_xsdk_v2019.1
```

# Backup and Sharing of Working Containers and Images
- Docker images and containers can be backed up to tar archive files
	- Similar to a Virtual Machine image created in VMWare or Virtualbox, you can store, share and later restore working containers from a tar archive
- A docker container is __*exported*__ to an archive file
- A docker image is __*saved*__ or __*exported*__ to an archive file
- A docker image that was __*saved*__ should be __*loaded*__ to restore the image from an archive
- A docker image or container that was __*exported*__ should be __*imported*__ to create a new image from an archive
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
$ docker stop xilinx_xsdk_v2019.1 
xilinx_xsdk_v2019.1
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_xsdk_v2019.1 xilinx-xsdk-backup:v2019.1
sha256:7de3792b5e7df359bb398286b9bf5f0430ecc6c6c70307ea8b8e6d71fdc202d5
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk-backup       v2019.1             7de3792b5e7d        8 seconds ago       12GB
xilinx-xsdk              v2019.1             6c9b7bee1673        About an hour ago   12GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-xsdk-v2019.1_image_backup_saved_02deadbeef93.tar xilinx-xsdk-backup:v2019.1
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xlnx-xsdk-v2019.1*
-rw------- 1 xilinx xilinx 12169561088 Jul 24 12:04 xlnx-xsdk-v2019.1_image_backup_saved_02deadbeef93.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-xsdk-backup:v2019.1 
Untagged: xilinx-xsdk-backup:v2019.1
Deleted: sha256:7de3792b5e7df359bb398286b9bf5f0430ecc6c6c70307ea8b8e6d71fdc202d5
Deleted: sha256:1be6ffffa53d335e3770f580ca6c9a7de2b4743502f42cd2b8825038312c7160
```

### Example: Restore a __*saved*__ container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with XSDK installed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working XSDK environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-xsdk-v2019.1_image_backup_02deadbeef93.tar 
695e85ed4473: Loading layer [==================================================>]   16.9kB/16.9kB
Loaded image: xilinx-xsdk-backup:v2019.1
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk-backup       v2019.1             7de3792b5e7d        8 minutes ago       12GB
xilinx-xsdk              v2019.1             6c9b7bee1673        About an hour ago   12GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-xsdk-backup:v2019.1 
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
7de3792b5e7d        9 minutes ago       /bin/bash                                       1.16kB              
<missing>           About an hour ago   |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   2.58MB              
<missing>           About an hour ago   |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   10.4GB              
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_XSDK_BATCH_CONFI…   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_XSDK_OFFLINE_INS…   0B                  
<missing>           About an hour ago   |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   2.61MB              
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           About an hour ago   |6 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User@…   79B                 
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           About an hour ago   |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   1.16GB              
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           About an hour ago   |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   39.6MB              
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           About an hour ago   |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   39.5MB              
<missing>           About an hour ago   |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   277MB               
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           4 weeks ago                                                         83.5MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk-backup:v2019.1 xilinx_xsdk_backup_v2019.1 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk-backup:v2019.1
DOCKER_CONTAINER_NAME: xilinx_xsdk_backup_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
96443825dcacc6c376cd51a18413779fd798f445676244ae5559592f49aa749d
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with XSDK installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-xsdk-v2019.1_container_backup_02deadbeef93.tar xilinx_xsdk_v2019.1
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-xsdk-v2019.1*
-rw------- 1 xilinx xilinx 11486608384 Jul 24 12:13 xlnx-xsdk-v2019.1_container_backup_02deadbeef93.tar
-rw------- 1 xilinx xilinx 12169561088 Jul 24 12:04 xlnx-xsdk-v2019.1_image_backup_saved_02deadbeef93.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working XSDK Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-xsdk-v2019.1_container_backup_02deadbeef93.tar xilinx-xsdk-imported:v2019.1
sha256:b9c81320ec6a1cbaa44f3a078fffbbf5366f861980d2d6633eb4da70aba0a3ce
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED              SIZE
xilinx-xsdk-imported     v2019.1             b9c81320ec6a        About a minute ago   11.3GB
xilinx-xsdk-backup       v2019.1             7de3792b5e7d        14 minutes ago       12GB
xilinx-xsdk              v2019.1             6c9b7bee1673        About an hour ago    12GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-xsdk-imported:v2019.1 
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
b9c81320ec6a        About a minute ago                       11.3GB              Imported from -
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk-imported:v2019.1 xilinx_xsdk_imported_v2019.1 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk-imported:v2019.1
DOCKER_CONTAINER_NAME: xilinx_xsdk_imported_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
8a8655ea2633c1576d682f07fe98ea8b47d3bb1da929f7a40c9af035f2401cfb
```
