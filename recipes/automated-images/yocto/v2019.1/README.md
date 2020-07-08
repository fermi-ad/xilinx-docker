[//]: # (README.md - Yocto v2019.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> Dockerfile
-> configs/
    -> keyboard_settings.conf
    -> xsdk_config_xsct_only.config
    -> xsdk_config_xsdk_full.config 
    -> XTerm
-> depends/
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Quickstart

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


- For Windows Powershell, execute the image generation script __*..\..\base_images\ubuntu_18.04.1\build_image.ps1*__
	- Note: If it appears that the script has hung and nothing is happening, look at the top of the Powershell command line window to see if there is a status message like this (it should be downloading the base Ubuntu Image)

```powershell
powershell:
Writing web request
	Writing request stream... (Number of bytes written: 17218561)
```

```powershell
powershell:
PS X:\...\base-images\ubuntu_18.04.1> .\build_image.ps1
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
-rw-r--r-- 1 xilinx xilinx 1554 Jul 24 14:00 _generated/configs/keyboard_settings.conf
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2019.1 Yocto Image (one time)

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
Removing intermediate container 2946039588d5                           
 ---> c32c06236868
Successfully built c32c06236868
Successfully tagged xilinx-yocto:v2019.1
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 11220
-----------------------------------
+ kill 11220
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 189: 11220 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Mon Sep 16 09:22:52 EDT 2019
ENDED   :Mon Sep 16 09:33:25 EDT 2019
-----------------------------------
```

## Create a working container (running in daemon mode) based on the yocto image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto             v2019.1             c32c06236868        32 minutes ago      2.77GB
ubuntu                   18.04.1             4112b3ccf856        4 weeks ago         83.5MB

$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto:v2019.1 xilinx_yocto_v2019.1 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto:v2019.1
DOCKER_CONTAINER_NAME: xilinx_yocto_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
b6fabd91eea270c82af3778d5dfeabfc871aee5b585d79fa4934bcdff46aa071

$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS               NAMES
b6fabd91eea2        xilinx-yocto:v2019.1   "/bin/bash"         32 seconds ago      Up 31 seconds                           xilinx_yocto_v2019.1

 $ docker inspect xilinx_yocto_v2019.1 | grep "MacAddress"
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
$ docker exec -d xilinx_yocto_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell ready to use yocto
```bash
xterm:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_yocto_v2019.1
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ xterm &
[1] 45
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$
```
- This launches an X-windows terminal shell for access to the container
```bash
xterm:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash:
bash:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ read escape sequence
[1]+  Done                    docker exec -d xilinx_yocto_v2019.1 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS               NAMES
b6fabd91eea2        xilinx-yocto:v2019.1   "/bin/bash"         3 minutes ago       Up 3 minutes                            xilinx_yocto_v2019.1
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
$ docker stop xilinx_yocto_v2019.1 
xilinx_yocto_v2019.1
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_yocto_v2019.1 xilinx-yocto-backup:v2019.1
sha256:beee5a4fdf55c7101815d9049f0c4faa526997e572bc3cc7abd1b320d002dd18
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto-backup      v2019.1             beee5a4fdf55        13 seconds ago      2.76GB
xilinx-yocto             v2019.1             3eaadab2e2ec        10 minutes ago      2.76GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-yocto-v2019.1_image_backup_saved_02deadbeef92.tar xilinx-yocto-backup:v2019.1
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xlnx-yocto-v2019.1*
-rw------- 1 xilinx xilinx 2815847424 Jul 24 14:37 xlnx-yocto-v2019.1_image_backup_saved_02deadbeef92.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-yocto-backup:v2019.1 
Untagged: xilinx-yocto-backup:v2019.1
Deleted: sha256:beee5a4fdf55c7101815d9049f0c4faa526997e572bc3cc7abd1b320d002dd18
Deleted: sha256:bc9813712b1aa72c600052f3e01ecb1c03217088a954b074154ad76dd935063e
```

### Example: Restore a __*saved*__ container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Yocto installed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working Yocto environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-yocto-v2019.1_image_backup_saved_02deadbeef92.tar 
b4a435678147: Loading layer [==================================================>]  349.7kB/349.7kB
Loaded image: xilinx-yocto-backup:v2019.1
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-yocto-backup      v2019.1             beee5a4fdf55        5 minutes ago       2.76GB
xilinx-yocto             v2019.1             3eaadab2e2ec        15 minutes ago      2.76GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-yocto-backup:v2019.1 
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
beee5a4fdf55        6 minutes ago       /bin/bash                                       314kB               
<missing>           16 minutes ago      |10 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   2.59MB              
<missing>           16 minutes ago      |10 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   2.62MB              
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           16 minutes ago      |8 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   3.82kB              
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG YOCTO_DIR                0B                  
<missing>           16 minutes ago      |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   163MB               
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           16 minutes ago      /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           16 minutes ago      |10 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User…   283MB               
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG YOCTO_MANIFEST_BRANCH    0B                  
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG YOCTO_MANIFEST_URL       0B                  
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG YOCTO_VER                0B                  
<missing>           17 minutes ago      /bin/sh -c #(nop)  ARG YOCTO_DIR                0B                  
<missing>           17 minutes ago      |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   1.87GB              
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           20 minutes ago      |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   39.6MB              
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           20 minutes ago      /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           20 minutes ago      |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   39.5MB              
<missing>           20 minutes ago      |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   277MB               
<missing>           21 minutes ago      /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           21 minutes ago      /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           21 minutes ago      /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           4 weeks ago                                                         83.5MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ./../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto-backup:v2019.1 xilinx_yocto_backup_v2019.1 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto-backup:v2019.1
DOCKER_CONTAINER_NAME: xilinx_yocto_backup_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
94ebd92c6a2838423ed273efc30df88fbf9f917c8aec4d6c44999b5de244a6a3
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Yocto installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-yocto-v2019.1_container_backup_02deadbeef92.tar xilinx_yocto_v2019.1
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-yocto-v2019.1*
-rw------- 1 xilinx xilinx 1942259712 Jul 24 14:43 xlnx-yocto-v2019.1_container_backup_02deadbeef92.tar
-rw------- 1 xilinx xilinx 2815847424 Jul 24 14:37 xlnx-yocto-v2019.1_image_backup_saved_02deadbeef92.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Petalinunx Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-yocto-v2019.1_container_backup_02deadbeef92.tar xilinx-yocto-imported:v2019.1
sha256:0ffb34f56ae17e1413c57e6713a98fc0ae01861c7986c5c3e892263a4603986d
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx_yocto_imported    v2019.1             0ffb34f56ae1        55 seconds ago      1.89GB
xilinx-yocto             v2019.1             3eaadab2e2ec        19 minutes ago      2.76GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-yocto-imported:v2019.1
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
0ffb34f56ae1        About a minute ago                       1.89GB              Imported from -                 
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-yocto-imported:v2019.1 xilinx_yocto_imported_v2019.1 02:de:ad:be:ef:92
DOCKER_IMAGE_NAME: xilinx-yocto-imported:v2019.1
DOCKER_CONTAINER_NAME: xilinx_yocto_imported_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:92
access control disabled, clients can connect from any host
a9339696d31190c2a98d2afc60bab612ebc4cd265ad971313e69a7546510535f
```

## Get started with a yocto build (in the running container)

### View Petalinux top-level recipes
```bash
bash:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ find . -name petalinux*.bb
./sources/meta-petalinux/recipes-core/images/petalinux-image-minimal.bb
./sources/meta-petalinux/recipes-core/images/petalinux-image-full.bb
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1
```

### View valid MACHINE targets
```bash
bash:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ ls sources/meta-xilinx/meta-xilinx-bsp/conf/machine/*.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/kc705-microblazeel.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microblazeel-v11.0-bs-cmp-mh-div-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microblazeel-v11.0-bs-cmp-ml-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/microzed-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/ml605-qemu-microblazeel.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/picozed-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/qemu-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/s3adsp1800-qemu-microblazeeb.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/ultra96-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/virt-versal.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc1254-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc1275-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc702-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zc706-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu102-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu104-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu106-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu111-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zcu1285-zynqmp.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zedboard-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zybo-linux-bd-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zybo-zynq7.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zynq-generic.conf
sources/meta-xilinx/meta-xilinx-bsp/conf/machine/zynqmp-generic.conf
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$
```

### Initialize a new build (example zcu106) on a shared drive outside of the container
```bash
bash:
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ mkdir -p /srv/shared/yocto/v2019.1/builds/zcu106
xilinx@xilinx_yocto_v2019:/opt/Xilinx/yocto/v2019.1$ source setupsdk /srv/shared/yocto/v2019.1/builds/zcu106
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

xilinx@xilinx_yocto_v2019:/srv/shared/yocto/v2019.1/builds/zcu106$
```

### Configure the yocto build (edit conf/local.conf)

#### Note on XSCT Tool Configuration:
- Ref: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841671/Using+meta-xilinx-tools+layer
- for v2019.1+ the XSCT tool is provided as a binary tarball and the Xilinx SDK does not need to be installed
- for v2018.2 and earlier, the Xilinx SDK must be installed manually and configured in the __*conf/local.conf*__
	- Uncomment the line defining __*XILINX_SDK_TOOLCHAIN*__ for v2018.2 and earlier builds
- This example is ased on my workflow and how I organize files and folders for development, which are located on a local machine hard drives and NAS storage locations that are mounted/accessible to the local development machine running the docker container.
- Edit or append the configuration file: __*./conf/local.conf*__
- Example modifications appended to the configuration file:
```bash
bash:
xilinx@xilinx_yocto_v2019:/srv/shared/yocto/v2019.1/builds/zcu106$ tail conf/local.conf
...
MACHINE = "zcu106-zynqmp"
SSTATE_MIRRORS = "file://.* file:///srv/sstate-mirrors/sstate-rel-v2019.1/aarch64"
SSTATE_DIR = "/srv/sstate-cache/v2019.1"
DL_DIR = "/srv/sstate-cache/downloads"
#XILINX_SDK_TOOLCHAIN = "/opt/Xilinx/SDK/2018.2"
HDF_BASE = "file://"
HDF_PATH = "/srv/hardware_definitions/xilinx-zcu106-2019.1/hardware/xilinx-zcu106-2019.1/xilinx-zcu106-2019.1.hdf"
HDF_FILE = "xilinx-zcu106-2019.1.hdf"
INHERIT += "buildhistory"
BUILD_HISTORY_COMMIT = "1"
xilinx@xilinx_yocto_v2019:/srv/shared/yocto/v2019.1/builds/zcu106$
```

#### Descriptions of main modifications
- Set the target platform (__*MACHINE*__)
	- Note: You can also specify this at build time from the command line
	- See valid machine target configurations available in .__*./../sources/meta-xilinx/meta-xilinx-bsp/conf/machine/<MACHINE>.conf*__
	- __*MACHINE = "zcu106-zynqmp"*__
- Set the target shared state mirror (__*SSTATE_MIRRORS*__)
	- Use the Petalinux shared state mirror bundle to accelerate the yocto build
		- Set as a docker run argument: ```-v /srv/sstate-mirrors:/srv/sstate-mirrors```
			- subdirectory ```/srv/sstate-mirrors/sstate-rel-v2019.1/aarch64```
	- __*SSTATE_MIRRORS = "file://.* file:///srv/sstate-mirrors/sstate-rel-v2019.1/aarch64"*__
- Set the shared state cache working directory (__*SSTATE_DIR*__)
	- Use a mounted shared state cache location (shared across docker containers)
		- Set as a docker run argument: ```-v /srv/sstate-cache:/srv/sstate-cache```
			- subdirectory ```/srv/sstate-cache/v2019.1```
	- __*SSTATE_DIR = "/srv/sstate-cache/v2019.1"*__
- Set the target downloads folder (__*DL_DIR*__)
	- Use a mounted shared downloads location (shared across docker containers)
		- Set as a docker run argument: ```-v /srv/sstate-cache:/srv/sstate-cache```
			- subdirectory ```/srv/sstate-cache/downloads```
	- __*DL_DIR = "/srv/sstate-cache/downloads"*__
- Set the SDK toolchain (for compiling FSBL, PMUFW, ...) (__*XILINX_SDK_TOOLCHAIN*__)
	- Use the SDK toolchain installed in the docker container
	- __*XILINX_SDK_TOOLCHAIN = "/opt/Xilinx/SDK/2018.2"*__
- Set the SDK toolchain version (__*XILINX_VER_MAIN*__)
	- __*XILINX_VER_MAIN = "2019.1"*__
- Set the hardware definition for the target platform (__*HDF_BASE*__, __*HDF_PATH*__, __*HDF_FILE*__)
	- Use a mounted shared location containing hardware definitions from the release bsps (shared across containers)
		- Set as a docker run argument: ```-v /srv/hardware_definitions:/srv/hardware_definitions```
	- __*HDF_BASE = "file://"*__
	- __*_HDF_PATH = "/srv/hardware_definitions/xilinx-zcu106-2019.1/hardware/xilinx-zcu106-2019.1"*__
	- __*HDF_FILE = "xilinx-zcu106-2019.1.hdf"*__
	- Note: Hardware definitions can be extracted from BSP files using the __*tar*__ command
- Example: Extract the hardware definitions from a BSP
```bash
bash:
$ tar -xf /srv/software/xilinx/bsps/xilinx-zcu106-v2019.1-final.bsp -C /srv/hardware_definitions
$ ls -al /srv/hardware_definitions/xilinx-zcu106-2019.1
total 56
drwxr-xr-x 3 xilinx xilinx  4096 May 25 07:31 components
-rw-r--r-- 1 xilinx xilinx   248 May 25 06:35 config.project
-rw-r--r-- 1 xilinx xilinx   186 May 25 06:35 .gitignore
drwxr-xr-x 3 xilinx xilinx  4096 May 25 08:16 hardware
drwxr-xr-x 2 xilinx xilinx  4096 May 25 08:16 .petalinux
drwxr-xr-x 3 xilinx xilinx  4096 May 25 07:34 pre-built
drwxr-xr-x 6 xilinx xilinx  4096 May 25 07:59 project-spec
-rw-r--r-- 1 xilinx xilinx 13494 May 25 07:34 README
-rw-r--r-- 1 xilinx xilinx  3949 May 25 07:31 README.hw
```
- Example: Find HDF files
```bash
bash:
$ find /srv/hardware_definitions/xilinx-zcu106-2019.1 -name *.hdf
/srv/hardware_definitions/xilinx-zcu106-2019.1/project-spec/hw-description/system.hdf
/srv/hardware_definitions/xilinx-zcu106-2019.1/hardware/xilinx-zcu106-2019.1/xilinx-zcu106-2019.1.sdk/design_1_wrapper.hdf
/srv/hardware_definitions/xilinx-zcu106-2019.1/hardware/xilinx-zcu106-2019.1/xilinx-zcu106-2019.1.hdf
/srv/hardware_definitions/xilinx-zcu106-2019.1/components/plnx_workspace/device-tree/device-tree/hardware_description.hdf
```

### (Optional) Enable the yocto buildhistory (conf/local.conf)
- Edit the configuration file: __*./conf/local.conf*__
	- __*INHERIT += "buildhistory"*__
	- __*BUILDHISTORY_COMMIT="1"*__


```bash
xterm:
xilinx@xilinx_yocto_v2019:/srv/shared/yocto/v2019.1/builds/zcu106$ bitbake petalinux-image-minimal -c listtasks
Parsing recipes: 100% |#################################################################################| Time: 0:01:21
Parsing of 2774 .bb files complete (0 cached, 2774 parsed). 3809 targets, 149 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION           = "1.40.0"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "ubuntu-18.04"
TARGET_SYS           = "aarch64-xilinx-linux"
MACHINE              = "zcu106-zynqmp"
DISTRO               = "petalinux"
DISTRO_VERSION       = "2019.1"
TUNE_FEATURES        = "aarch64"
TARGET_FPU           = ""
meta                 
meta-poky            = "v2019.1_working:7499683610483cdb05ed35f2173cd96b6dd5852f"
meta-perl            
meta-python          
meta-filesystems     
meta-gnome           
meta-multimedia      
meta-networking      
meta-webserver       
meta-xfce            
meta-initramfs       
meta-oe              = "v2019.1_working:d2e6a2d13cfe30cb729c1089030f57fb3f3e45ad"
meta-browser         = "v2019.1_working:d7e5fab5ec331edede71da7829d4b0d9bfc80ba4"
meta-qt5             = "v2019.1_working:fb4ef4dd7bccfb53a5186c031105ea29320420ce"
meta-xilinx-bsp      
meta-xilinx-contrib  = "v2019.1_working:f4c53cc332397b5e5ee17f42169f7c87808c9dc7"
meta-xilinx-tools    = "v2019.1_working:881132b62dc01e57b8d9ace458a0005528179e14"
meta-petalinux       = "v2019.1_working:5d9a1b621c8198e7b5b87b18dc124877787bb309"
meta-virtualization  = "v2019.1_working:6743df6e68c8fa145a6472bac81a87b57f19f84d"
meta-openamp         = "v2019.1_working:e27cba5e58a4022a7c37a94bc6f9900cef4c717c"

NOTE: Fetching xsct binary tarball from http://petalinux.xilinx.com/sswreleases/rel-v2019/xsct-trim/xsct-2019-1.tar.xz;md5sum=7fb75c921050ad579db111906f997681;downloadfilename=xsct_2019.1.tar.xz
NOTE: Extracting external xsct-tarball to sysroots
NOTE: Fetching uninative binary shim from http://downloads.yoctoproject.org/releases/uninative/2.3/x86_64-nativesdk-libc.tar.bz2;sha256sum=c6954563dad3c95608117c6fc328099036c832bbd924ebf5fdccb622fc0a8684
Initialising tasks: 100% |##############################################################################| Time: 0:00:01
NOTE: Executing RunQueue Tasks
do_build                       Default task for a recipe - depends on all other normal tasks required to 'build' a recipe
do_checkuri                    Validates the SRC_URI value
do_clean                       Removes all output files for a target
do_cleanall                    Removes all output files, shared state cache, and downloaded source files for a target
do_cleansstate                 Removes all output files and shared state cache for a target
do_compile                     Compiles the source in the compilation directory
do_configure                   Configures the source by enabling and disabling any build-time and configuration options for the software being built
do_devpyshell                  Starts an interactive Python shell for development/debugging
do_devshell                    Starts a shell with the environment set up for development/debugging
do_fetch                       Fetches the source code
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
do_package_write_rpm_setscene  Creates the actual RPM packages and places them in the Package Feed area (setscene version)
do_packagedata                 Creates package metadata used by the build system to generate the final packages
do_packagedata_setscene        Creates package metadata used by the build system to generate the final packages (setscene version)
do_patch                       Locates patch files and applies them to the source code
do_populate_lic                Writes license information for the recipe that is collected later when the image is constructed
do_populate_lic_deploy         
do_populate_lic_setscene       Writes license information for the recipe that is collected later when the image is constructed (setscene version)
do_populate_sdk                Creates the file and directory structure for an installable SDK
do_populate_sdk_ext            
do_populate_sysroot_setscene   Copies a subset of files installed by do_install into the sysroot in order to make them available to other recipes (setscene version)
do_prepare_recipe_sysroot      
do_rootfs                 
```