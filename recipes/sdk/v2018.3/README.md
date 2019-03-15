[//]: # (Readme_xsdk_v2018.3.md - XSDK v2018.3 Build Environment)

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
   -> Xilinx_SDK_2018.3_1207_2324_Lin64.bin
   -> (Xilinx_XSDK_2018.3_1207_2324_Lin64.tar.gz)
-> include/
   -> configuration.sh
```

# Quickstart
## Download Xilinx SDK Web Installer

Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.

## Download the v2018.3 Xilinx SDK Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx SDK v2018.3
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2018.3_1207_2324_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2018-3.html
- Place the installer binary (or a link to it) in the ./depends folder

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## Generate a base Ubuntu 16.04.3 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_16.04.3/scripts/build_image.sh*__

```bash
bash:
$ pushd ../../base-images/ubuntu-16.04.3
$ ./build_image.sh
Base Release Image [Missing] ubuntu-base-16.04.3-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.3/release/ubuntu-base-16.04.3-base-amd64.tar.gz
--2018-10-04 10:08:41--  http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.3/release/ubuntu-base-16.04.3-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 91.189.88.168
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 46119172 (44M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-16.04.3-base-amd64.tar.gz’

depends/ubuntu-base-16.04.3-base 100%[==========================================================>]  43.98M  1.80MB/s    in 25s     

2018-10-04 10:09:07 (1.74 MB/s) - ‘depends/ubuntu-base-16.04.3-base-amd64.tar.gz’ saved [46119172/46119172]

Base Relese Image Download [Good] ubuntu-base-16.04.3-base-amd64.tar.gz
sha256:cee3cd7394ee363d584465e84d1446d26ffea20457abcdfe959a206bbf3eb2c5
REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
ubuntu              16.04.3             cee3cd7394ee        Less than a second ago   120MB
```

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

## Generate Yocto Image Dependencies (one time)

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
		- ```CreateProgramGroupShortcuts=1```
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
			- download directory: ```/opt/Xilinx/Downloads/2018.3```
			- platform selection: ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/2018.3```
		- Disk Space Required:
			- ```Download Size: 1.18 GB```
			- ```Disk Space Required: 1.18 GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```
- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1553 Jan 23 12:33 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1245 Mar 15 11:05 xsdk_config_xsdk_full.config
-rw-r--r-- 1 xilinx xilinx 1373663062 Jan 23 12:43 _generated/depends/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2018.3 Xilinx SDK Image (one time)

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
Removing intermediate container bc8fecfe491d
 ---> cd0bddde9455
Successfully built cd0bddde9455
Successfully tagged xilinx-xsdk:v2018.3
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 24660
-----------------------------------
+ kill 24660
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 185: 24660 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Fri Mar 15 11:42:53 EDT 2019
ENDED   :Fri Mar 15 11:49:04 EDT 2019
-----------------------------------
```

## Create a working container (running in daemon mode) based on the yocto image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk                     v2018.3             cd0bddde9455        19 minutes ago      11GB
ubuntu              			16.04.3             cee3cd7394ee        About an hour ago   120MB

$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk:v2018.3 xilinx_xsdk_v2018.3 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk:v2018.3
DOCKER_CONTAINER_NAME: xilinx_xsdk_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
b891b977f2dc315c18c5b648ff550084e420cf95c5be3666cc28e2c5534b1f83

$ docker ps -a
CONTAINER ID        IMAGE                                   COMMAND             CREATED              STATUS              PORTS               NAMES
b891b977f2dc        xilinx-xsdk:v2018.3                     "/bin/bash"         18 seconds ago       Up 17 seconds                           xilinx_xsdk_v2018.3

$ docker inspect xilinx_xsdk_v2018.3 | grep "MacAddress"
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
$ docker exec -d xilinx_xsdk_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell ready to use yocto
```bash
xterm:
xilinx@xilinx_xsdk_v2018:/opt/Xilinx$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_xsdk_v2018.3
xilinx@xilinx_xsdk_v2018:/opt/Xilinx$ xterm &
[1] 146
xilinx@xilinx_xsdk_v2018:/opt/Xilinx$ 
```
- This launches an X-windows terminal shell for access to the container
```bash
xterm:
xilinx@xilinx_xsdk_v2018:/opt/Xilinx$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash
bash:
xilinx@xilinx_xsdk_v2018:/opt/Xilinx$ read escape sequence
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                                   COMMAND             CREATED             STATUS              PORTS               NAMES
b891b977f2dc        xilinx-xsdk:v2018.3                     "/bin/bash"         9 minutes ago       Up 9 minutes                            xilinx_xsdk_v2018.3
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
$ docker stop xilinx_xsdk_v2018.3 
xilinx_xsdk_v2018.3
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_xsdk_v2018.3 xilinx-xsdk-backup:v2018.3
sha256:d7acb1ef89a21267a42c313e5802d03db5ad7adf22a5a5a3d0bf731f5f371065
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk-backup              v2018.3             d7acb1ef89a2        17 seconds ago      11GB
xilinx-xsdk                     v2018.3             2750dfcb3ffa        About an hour ago   11GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-xsdk-v2018.3_image_backup_saved_02deadbeef93.tar xilinx-xsdk-backup:v2018.3
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xlnx-xsdk-v2018.3*
-rw------- 1 xilinx xilinx 11096830464 Mar 15 14:06 xlnx-xsdk-v2018.3_image_backup_02deadbeef93.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-xsdk-backup:v2018.3 
Untagged: xilinx-xsdk-backup:v2018.3
Deleted: sha256:d7acb1ef89a21267a42c313e5802d03db5ad7adf22a5a5a3d0bf731f5f371065
Deleted: sha256:084cbde3cd8393505879fdd69e039077f29637aa4570aadb3c65ffc42645a533
```

### Example: Restore a __*saved*__ container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with XSDK installed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working XSDK environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-xsdk-v2018.3_image_backup_02deadbeef93.tar 
70fa929913c2: Loading layer [==================================================>]  10.34MB/10.34MB
Loaded image: xilinx-xsdk-backup:v2018.3
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk-backup              v2018.3             d7acb1ef89a2        4 minutes ago       11GB
xilinx-xsdk                     v2018.3             2750dfcb3ffa        About an hour ago   11GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-xsdk-backup:v2018.3 
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
d7acb1ef89a2        4 minutes ago       /bin/bash                                       10.3MB              
<missing>           About an hour ago   |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   2.6MB               
<missing>           About an hour ago   |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   9.51GB              
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_XSDK_BATCH_CONFI…   0B                  
<missing>           About an hour ago   /bin/sh -c #(nop)  ARG XLNX_XSDK_OFFLINE_INS…   0B                  
<missing>           About an hour ago   |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   2.63MB              
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
<missing>           About an hour ago   |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   1.03GB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           2 hours ago         |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   35.2MB              
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   34.8MB              
<missing>           2 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   255MB               
<missing>           2 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           4 days ago                                                          120MB               Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk-backup:v2018.3 xilinx_xsdk_backup_v2018.3 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk-backup:v2018.3
DOCKER_CONTAINER_NAME: xilinx_xsdk_backup_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
7aadefdcf5b6e31e46c8f88d399e2091abc656dab3c3fd224e7c5def1b9c8b98
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Petalinux installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-xsdk-v2018.3_container_backup_02deadbeef94.tar xilinx_xsdk_v2018.3
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-yocto-v2018.3*
-rw------- 1 xilinx xilinx 10444639744 Mar 15 14:10 xlnx-xsdk-v2018.3_container_backup_02deadbeef94.tar
-rw------- 1 xilinx xilinx 11096830464 Mar 15 14:06 xlnx-xsdk-v2018.3_image_backup_02deadbeef93.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working XSDK Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-xsdk-v2018.3_container_backup_02deadbeef94.tar xilinx-xsdk-imported:v2018.3
sha256:980c6da45f06f45c16d6aa86c52672d80796a17c86300a1bba282c6ba950b6ae
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-xsdk-imported            v2018.3             980c6da45f06        16 seconds ago      10.4GB
xilinx-xsdk-backup              v2018.3             d7acb1ef89a2        8 minutes ago       11GB
xilinx-xsdk                     v2018.3             2750dfcb3ffa        About an hour ago   11GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-xsdk-imported:v2018.3 
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
980c6da45f06        About a minute ago                       10.4GB              Imported from -                 
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-xsdk-imported:v2018.3 xilinx_xsdk_imported_v2018.3 02:de:ad:be:ef:93
DOCKER_IMAGE_NAME: xilinx-xsdk-imported:v2018.3
DOCKER_CONTAINER_NAME: xilinx_xsdk_imported_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:93
access control disabled, clients can connect from any host
218012d6569fcbd5c66924df67520c004de6d2c77760c21192c3f3372bd168c0
```
