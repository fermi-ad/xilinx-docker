[//]: # (Readme_yocto_v2018.3.md - Yocto v2018.3 Build Environment)

# Organization
```
-> Dockerfile.yocto_v2018.3
-> configs/
   -> keyboard_settings.conf
   -> xsdk_config_xsct_only.config
   -> xsdk_config_xsdk_full.config 
   -> XTerm
-> depends/
   -> (mali-400-userspace-with-android-2018.3.tar)
-> scripts/bash/
   -> generate_xilinx_yocto_depends_v2018.3.sh
   -> build_yocto_image_v2018.3.sh
-> scripts/bash/include/
   -> common_v2018.3.sh
   -> yocto_configuration.sh
-> docs/
   -> Readme_yocto_v2018.3.md (this file)
```

# Quickstart

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
- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1553 Jan 23 12:33 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 305602560 Dec 19 22:26 _generated/depends/mali-400-userspace.tar
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2018.3 Yocto Image (one time)

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
Removing intermediate container 8a6e99440774
 ---> 3b8c2953f9b6
Successfully built 3b8c2953f9b6
Successfully tagged xilinx-yocto:v2018.3
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 3363
-----------------------------------
+ kill 3363
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 196:  3363 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Thu Mar 14 17:22:19 EDT 2019
ENDED   :Thu Mar 14 17:29:01 EDT 2019
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
xilinx-yocto                    v2018.3             3b8c2953f9b6        4 hours ago         11.5GB
ubuntu              			16.04.3             cee3cd7394ee        About an hour ago   120MB

$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto:v2018.3 xilinx_yocto_v2018.3 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto:v2018.3
DOCKER_CONTAINER_NAME: xilinx_yocto_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
faa3be44359615f140b587b77a141996e40adfb3236e4c027288e750219c5239

$ docker ps -a
CONTAINER ID        IMAGE                                   COMMAND             CREATED             STATUS              PORTS               NAMES
faa3be443596        xilinx-yocto:v2018.3                    "/bin/bash"         14 seconds ago      Up 13 seconds                           xilinx_yocto_v2018.3

 $ docker inspect xilinx_petalinux_v2018.3 | grep "MacAddress"
            "MacAddress": "02:de:ad:be:ef:92",
            "MacAddress": "02:de:ad:be:ef:92",
                    "MacAddress": "02:de:ad:be:ef:92",
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
$ docker exec -d xilinx_yocto_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell ready to use yocto
```bash
xterm:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_yocto_v2018.3
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ xterm &
[1] 45
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$
```
- This launches an X-windows terminal shell for access to the container
```bash
xterm:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash:
bash:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ read escape sequence
[1]+  Done                    docker exec -d xilinx_yocto_v2018.3 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                                   COMMAND             CREATED             STATUS              PORTS               NAMES
faa3be443596        xilinx-yocto:v2018.3                    "/bin/bash"         7 minutes ago       Up 7 minutes                            xilinx_yocto_v2018.3
```

# Backup and Sharing of Working Containers and Images
- Docker images and containers can be backed up to tar archive files
	- Similar to a Virtual Machine image created in VMWare or Virtualbox, you can store, share and later restore working containers from a tar archive
- A docker container is __*exported*__ to an archive file
- A docker image is __*saved*__ or __*exported*__ to an archive file
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
$ docker stop xilinx_yocto_v2018.3 
xilinx_yocto_v2018.3
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_yocto_v2018.3 xilinx-yocto-backup:v2018.3
sha256:2d89476924e277a89e1593064f84c6949926aa9acdec7e803cc166c8333821ca
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto-backup             v2018.3             2d89476924e2        16 seconds ago      11.5GB
xilinx-yocto                    v2018.3             3b8c2953f9b6        4 hours ago         11.5GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-yocto-v2018.3_image_backup_saved_02deadbeef92.tar xilinx-yocto-backup:v2018.3
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xlnx-yocto-v2018.3*
-rw------- 1 xilinx xilinx 11616976384 Mar 14 21:50 xlnx-yocto-v2018.3_image_backup_saved_02deadbeef92.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-yocto-backup:v2018.3 
Untagged: xilinx-yocto-backup:v2018.3
Deleted: sha256:2d89476924e277a89e1593064f84c6949926aa9acdec7e803cc166c8333821ca
Deleted: sha256:6af3df1065f36d8daf566840c286d4c73710b17c6acdf72a8bd8a2d8a3745e53
```

### Example: Restore a container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Vivado Tools installed and licensed
- There are two ways to create a docker image from an archive depending on if you want to maintain the recorded history of an archived image
	- __*docker import__* imports a flattened copy of the archived image filesystem into a new docker image
		- An import operation creates a new image with a name you specify in the local docker image cache
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker import*__ to bring in an archived image
- Restore a working Vivado environment image from the archive (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-yocto-v2018.3_image_backup_saved_02deadbeef92.tar xilinx-petalinux-imported:v2018.3
sha256:dd3e13c29ebf933a3792ecb1a9cd5a8ba3e3facaf66210e5e7eb1ab71f9694b9
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto-imported       v2018.3             dd3e13c29ebf        28 seconds ago      11.6GB
xilinx-yocto                    v2018.3             3b8c2953f9b6        4 hours ago         11.5GB
```

- See that an imported image has no history
```bash
$ docker history xilinx-yocto-imported:v2018.3 
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
dd3e13c29ebf        About a minute ago                       11.6GB              Imported from -
```

- Create a working container based on this image
```bash
$ ../../../tools/bash/run_image_x11_macaddr xilinx-yocto-imported:v2018.3 xilinx_yocto_imported_v2018.3 02:de:ad:be:ef:92
```

### Use __*docker load*__ to bring in an archived image
- Restore a working Vivado environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-yocto-v2018.3_image_backup_saved_02deadbeef92.tar 
cd7ce8e61c9e: Loading layer [==================================================>]  22.02kB/22.02kB
Loaded image: xilinx-yocto-backup:v2018.3
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux-imported       v2018.3             dd3e13c29ebf        4 minutes ago       11.6GB
xilinx-yocto-backup             v2018.3             2d89476924e2        10 minutes ago      11.5GB
xilinx-yocto                    v2018.3             3b8c2953f9b6        4 hours ago         11.5GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-yocto-backup:v2018.3 
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
2d89476924e2        10 minutes ago      /bin/bash                                       2.4kB               
<missing>           4 hours ago         |12 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   2.61MB              
<missing>           4 hours ago         |12 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   9.13GB              
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG YOCTO_DIR                0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_XSDK_BATCH_CONFI…   0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_XSDK_OFFLINE_INS…   0B                  
<missing>           5 hours ago         |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   2.64MB              
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           5 hours ago         |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   83.4MB              
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           5 hours ago         |10 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User…   261MB               
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG YOCTO_MANIFEST_BRANCH    0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG YOCTO_MANIFEST_URL       0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG YOCTO_VER                0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG YOCTO_DIR                0B                  
<missing>           5 hours ago         |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   1.57GB              
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           5 hours ago         |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   35.2MB              
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           5 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   34.8MB              
<missing>           5 hours ago         |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   255MB               
<missing>           5 hours ago         /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           5 hours ago         /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           3 days ago                                                          120MB               Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ./../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto-backup:v2018.3 xilinx_yocto_backup_v2018.3 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto-backup:v2018.3
DOCKER_CONTAINER_NAME: xilinx_yocto_backup_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
94ebd92c6a2838423ed273efc30df88fbf9f917c8aec4d6c44999b5de244a6a3
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Petalinux installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-yocto-v2018.3_container_backup_02deadbeef92.tar xilinx_yocto_v2018.3
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-yocto-v2018.3*
-rw------- 1 xilinx xilinx 10889808896 Mar 14 22:04 xlnx-yocto-v2018.3_container_backup_02deadbeef92.tar
-rw------- 1 xilinx xilinx 11616976384 Mar 14 21:50 xlnx-yocto-v2018.3_image_backup_saved_02deadbeef92.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Petalinunx Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-yocto-v2018.3_container_backup_02deadbeef92.tar xilinx_yocto_imported:v2018.3
sha256:4b7c4ed81a352f88cc7c6750efc3141d7e6c67dfa429817343931022614765fd
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto-imported           v2018.3             4b7c4ed81a35        16 seconds ago      10.8GB
xilinx-yocto                    v2018.3             3b8c2953f9b6        5 hours ago         11.5GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-yocto-imported:v2018.3 
IMAGE               CREATED             CREATED BY          SIZE                COMMENT
4b7c4ed81a35        50 seconds ago                          10.8GB              Imported from -                 
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto-imported:v2018.3 xilinx_yocto_imported_v2018.3 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto-imported:v2018.3
DOCKER_CONTAINER_NAME: xilinx_yocto_imported_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
812c80544c1c3fa797042b85a72f08b23eb63e8cfcb8c9f20ee2291dd8616499
```

=============== UPDATE ME ============================

## Get started with a yocto build (in the running container)

### View Petalinux top-level recipes
```bash
bash:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ find . -name petalinux*.bb
./sources/meta-petalinux/recipes-core/images/petalinux-minimal.bb
./sources/meta-petalinux/recipes-core/images/petalinux-image-minimal.bb
./sources/meta-petalinux/recipes-core/images/petalinux-image-full.bb
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3
```

### View valid MACHINE targets
```bash
bash:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ ls sources/meta-xilinx/meta-xilinx-bsp/conf/machine/*.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/kc705-microblazeel.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microblazeel-v10.0-bs-cmp-mh-div-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microblazeel-v10.0-bs-cmp-ml-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microzed-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/ml605-qemu-microblazeel.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/picozed-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/qemu-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/s3adsp1800-qemu-microblazeeb.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/ultra96-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc1254-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc1275-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc702-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc706-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu100-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu102-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu104-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu106-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu111-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zedboard-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zybo-linux-bd-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zybo-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zynq-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zynqmp-generic.conf
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$
```

### Initialize a new build (example zcu106) on a shared drive outside of the container
```bash
bash:
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ mkdir -p /srv/shared/yocto/v2018.3/builds/zcu106
xilinx@xilinx_yocto_v2018:/opt/Xilinx/yocto/v2018.3$ source setupsdk /srv/shared/yocto/v2018.3/builds/zcu106
You had no conf/local.conf file. This configuration file has therefore been
created for you with some default values. You may wish to edit it to, for
example, select a different MACHINE (target hardware). See conf/local.conf
for more information as common configuration options are commented.

You had no conf/bblayers.conf file. This configuration file has therefore been
created for you with some default values. To add additional metadata layers
into your configuration please add entries to conf/bblayers.conf.

The Yocto Project has extensive documentation about OE including a reference
manual which can be found at:
    http://yoctoproject.org/documentation

For more information about OpenEmbedded see their website:
    http://www.openembedded.org/

xilinx@xilinx_yocto_v2018:/srv/shared/yocto/v2018.3/builds/zcu106$
```

### Configure the yocto build (edit conf/local.conf)

#### Note on XSCT Tool Configuration:
- Ref: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841671/Using+meta-xilinx-tools+layer
- for v2018.3+ the XSCT tool is provided as a binary tarball and the Xilinx SDK does not need to be installed
- for v2018.2 and earlier, the Xilinx SDK must be installed manually and configured in the __*conf/local.conf*__
- This example is ased on my workflow and how I organize files and folders for development, which are located on a local machine hard drives and NAS storage locations that are mounted/accessible to the local development machine running the docker container.
- Edit or append the configuration file: __*./conf/local.conf*__
- Example modifications appended to the configuration file:
```bash
bash:
xilinx@xilinx_yocto_v2018:/srv/shared/yocto/v2018.3/builds/zcu106$ tail conf/local.conf
MACHINE = "zcu106-zynqmp"
SSTATE_MIRRORS = "file://.* file:///srv/sstate-mirrors/sstate-rel-v2018.3/aarch64"
SSTATE_DIR = "/srv/sstate-cache/v2018.3"
DL_DIR = "/srv/sstate-cache/downloads"
XILINX_SDK_TOOLCHAIN = "/opt/Xilinx/SDK/2018.3"
HDF_BASE = "file://"HDF_PATH = "/srv/hardware_definitions/xilinx-zcu106-2018.3/hardware/xilinx-zcu106-2018.3/xilinx-zcu106-2018.3.hdf"
HDF_FILE = "xilinx-zcu106-2018.3.hdf"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"
xilinx@xilinx_yocto_v2018:/srv/shared/yocto/v2018.3/builds/zcu106$
```

#### Descriptions of main modifications
- Set the target platform (__*MACHINE*__)
	- Note: You can also specify this at build time from the command line
	- See valid machine target configurations available in .__*./../sources/meta-xilinx/meta-xilinx-bsp/conf/machine/<MACHINE>.conf*__
	- __*MACHINE = "zcu106-zynqmp"*__
- Set the target shared state mirror (__*SSTATE_MIRRORS*__)
	- Use the Petalinux shared state mirror bundle to accelerate the yocto build
		- Set as a docker run argument: ```-v /srv/sstate-mirrors:/srv/sstate-mirrors```
			- subdirectory ```/srv/sstate-mirrors/sstate-rel-v2018.3/aarch64```
	- __*SSTATE_MIRRORS = "file://.* file:///srv/sstate-mirrors/sstate-rel-v2018.3/aarch64"*__
- Set the shared state cache working directory (__*SSTATE_DIR*__)
	- Use a mounted shared state cache location (shared across docker containers)
		- Set as a docker run argument: ```-v /srv/sstate-cache:/srv/sstate-cache```
			- subdirectory ```/srv/sstate-cache/v2018.3```
	- __*SSTATE_DIR = "/srv/sstate-cache/v2018.3"*__
- Set the target downloads folder (__*DL_DIR*__)
	- Use a mounted shared downloads location (shared across docker containers)
		- Set as a docker run argument: ```-v /srv/sstate-cache:/srv/sstate-cache```
			- subdirectory ```/srv/sstate-cache/downloads```
	- __*DL_DIR = "/srv/sstate-cache/downloads"*__
- Set the SDK toolchain (for compiling FSBL, PMUFW, ...) (__*XILINX_SDK_TOOLCHAIN*__)
	- Use the SDK toolchain installed in the docker container
	- __*XILINX_SDK_TOOLCHAIN = "/opt/Xilinx/SDK/2018.3"*__
- Set the SDK toolchain version (__*XILINX_VER_MAIN*__)
	- __*XILINX_VER_MAIN = "2018.3"*__
- Set the hardware definition for the target platform (__*HDF_BASE*__, __*HDF_PATH*__, __*HDF_FILE*__)
	- Use a mounted shared location containing hardware definitions from the release bsps (shared across containers)
		- Set as a docker run argument: ```-v /srv/hardware_definitions:/srv/hardware_definitions```
	- __*HDF_BASE = "file://"*__
	- __*_HDF_PATH = "/srv/hardware_definitions/xilinx-zcu106-2018.3/hardware/xilinx-zcu106-2018.3"*__
	- __*HDF_FILE = "xilinx-zcu106-2018.3.hdf"*__
	- Note: Hardware definitions can be extracted from BSP files using the __*tar*__ command
- Example: Extract the hardware definitions from a BSP
```bash
bash:
$ tar -xf /srv/software/xilinx/bsps/xilinx-zcu106-v2018.3-final.bsp -C /srv/hardware_definitions
$ ls -al /srv/hardware_definitions/xilinx-zcu106-2018.3
total 40
drwxr-xr-x 3 xilinx xilinx  4096 Dec  6 07:10 components
-rw-r--r-- 1 xilinx xilinx   248 Dec  6 06:13 config.project
drwxr-xr-x 3 xilinx xilinx  4096 Dec  6 08:40 hardware
drwxr-xr-x 3 xilinx xilinx  4096 Dec  6 08:11 pre-built
drwxr-xr-x 6 xilinx xilinx  4096 Dec  6 08:11 project-spec
-rw-r--r-- 1 xilinx xilinx 13130 Dec  6 08:11 README
-rw-r--r-- 1 xilinx xilinx  3949 Dec  6 07:09 README.hw
```
- Example: Find HDF files
```bash
bash:
$ find /srv/hardware_definitions/xilinx-zcu106-2018.3 -name *.hdf
/srv/hardware_definitions/xilinx-zcu106-2018.3/project-spec/hw-description/system.hdf
/srv/hardware_definitions/xilinx-zcu106-2018.3/hardware/xilinx-zcu106-2018.3/xilinx-zcu106-2018.3.sdk/design_1_wrapper.hdf
/srv/hardware_definitions/xilinx-zcu106-2018.3/hardware/xilinx-zcu106-2018.3/xilinx-zcu106-2018.3.hdf
/srv/hardware_definitions/xilinx-zcu106-2018.3/components/plnx_workspace/device-tree/device-tree/hardware_description.hdf
```

### (Optional) Enable the yocto buildhistory (conf/local.conf)
- Edit the configuration file: __*./conf/local.conf*__
	- __*INHERIT += "buildhistory"*__
	- __*BUILDHISTORY_COMMIT="1"*__


```bash
xterm:
xilinx@xilinx_yocto_v2018:/srv/shared/yocto/v2018.3/builds/zcu106$ bitbake petalinux-image-minimal -c listtasks
Parsing recipes: 100% |########################################################################################| Time: 0:01:18
Parsing of 2566 .bb files complete (0 cached, 2566 parsed). 3458 targets, 136 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION           = "1.36.0"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "ubuntu-16.04"
TARGET_SYS           = "aarch64-xilinx-linux"
MACHINE              = "zcu106-zynqmp"
DISTRO               = "petalinux"
DISTRO_VERSION       = "2018.3"
TUNE_FEATURES        = "aarch64"
TARGET_FPU           = ""
meta                 
meta-poky            = "v2018.3_working:3be15ed93e52d797250ad90467760eb1fd7eca56"
meta-perl            
meta-python          
meta-filesystems     
meta-gnome
meta-networking      
meta-webserver       
meta-xfce            
meta-initramfs       
meta-oe              = "v2018.3_working:83fbd5d5d605de13f47263fab680d910375e1f95"
meta-browser         = "v2018.3_working:c5ff301787ef76eec57ca500ec9d1ccf0f74b488"
meta-qt5             = "v2018.3_working:f7e16aeeaa58cd7cc166f16d8537a8b3627e0397"
meta-xilinx-bsp      
meta-xilinx-contrib  = "v2018.3_working:7922f16dfa5308fb5419a80f513bb07c0384f95e"
meta-xilinx-tools    = "v2018.3_working:b286943d7d468e9ff10b9f9662767e8c71f104d1"
meta-petalinux       = "v2018.3_working:254edec8368c3d30676135365734abe06e596881"
meta-virtualization  = "v2018.3_working:df7b7937b9c91eeea05665c0b69ddcf435cddbcb"
meta-openamp         = "v2018.3_working:fb5fbc77fa5595ed291b886abe9555a91e67d241"

NOTE: Fetching xsct binary tarball from http://petalinux.xilinx.com/sswreleases/rel-v2018.3/xsct-trim/xsct.tar.xz;md5sum=27533cf9b7ebb0ef1572b6c481746749
NOTE: Extracting external xsct-tarball to sysroots
Initialising tasks: 100% |#####################################################################################| Time: 0:00:04
NOTE: Executing RunQueue Tasks
do_build                       Default task for a recipe - depends on all other normal tasks required to 'build' a recipe
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
do_rootfs                      Creates the root filesystem (file and directory structure) for an image
do_rootfs_wicenv               
do_sdk_depends                 
do_unpack                      Unpacks the source code into a working directory
NOTE: Tasks Summary: Attempted 1 tasks of which 0 didn't need to be rerun and all succeeded.
NOTE: Writing buildhistory
xilinx@xilinx_yocto_v2018:/srv/shared/yocto/v2018.3/builds/zcu106$
```