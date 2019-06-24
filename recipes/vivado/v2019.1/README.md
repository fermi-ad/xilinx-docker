[//]: # (README.md - Vivado v2019.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> Dockerfile
-> configs/
	-> keyboard_settings.conf
	-> xlnx_vivado_system_edition.config
	-> XTerm
-> depends/
	-> Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin
	-> (Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.tar.gz)
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Need to determine Vivado dependencies?
## Download ldd-recursive.pl
https://downloads.sourceforge.net/project/recursive-ldd/ldd-recursive.pl?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Frecursive-ldd%2Ffiles%2Flatest%2Fdownload&ts=1537542905

## Run the ldd-recursive.pl script on the Vivado executable
```bash
bash:
$ perl ldd-recursive.pl /opt/Xilinx/Vivado/2019.1/bin/unwrapped/lnx64.o/vivado -uniq
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-1/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Vivado Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Vivado HLx Webpack Linux Installer v2019.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-1.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_1/ug973-vivado-release-notes-install-license.pdf
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
PS X:\...\base-images\ubuntu-18.04.1> .\build_image.ps1
```

## Generate Vivado Image Dependencies (one time)

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


- Xilinx Vivado batch mode configuration (generate)
	- Select Vivado HL System Edition: option ```3```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0,Enable WebTalk for Vivado to send usage statistics to Xilinx (Always enabled for WebPACK license):0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=0```
	- Save with ```:wq```


- Xilinx Vivado installer (download only)
	- This should launch an X11-based Xilinx Vivado Setup window on your host
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
			- ```Download Size: 22.46 GB```
			- ```Disk Space Required: 22.46 GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1554 Jun 23 01:08 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1873 Jun 23 01:11 _generated/configs/xlnx_vivado_system_edition.config
-rw-r--r-- 1 xilinx xilinx 24248813183 Jun 23 02:13 _generated/depends/
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2018.3 Vivado Image (one time)

### Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__
- For Windows Hosts:
	- Modify build options in the file __*./include/configuration.ps1*__

### Execute the image build script
- Note: Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.1)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
Xilinx MALI Binaries: [Good] depends/mali-400-userspace.tar
Xilinx Vivado Web Installer: [Good] depends/Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.bin
Xilinx Vivado Offline Installer: [Good] depends/Xilinx_Vivado_SDK_Web_2019.1_0524_1430_Lin64.tar.gz
XTerm Configuration File: [Good] configs/XTerm

...

-----------------------------------
Image Build Complete...
STARTED :Sun Jun 23 22:36:49 EDT 2019
ENDED   :Sun Jun 23 23:00:23 EDT 2019
-----------------------------------
```

## Create a working container (running in daemon mode) based on the vivado image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress

- List local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado            v2019.1             0570aa89c8b9        9 hours ago         52.5GB
ubuntu                   18.04.1             4112b3ccf856        42 hours ago        83.5MB
```

- Use the included tool script to create a Container based on the Vivado image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-vivado:v2019.1 xilinx_vivado_v2019.1 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado:v2019.1
DOCKER_CONTAINER_NAME: xilinx_vivado_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
access control disabled, clients can connect from any host
7c0d7e6e5e6eb0646cff6e2836ebfeab2b0632c6ca56668c230ec995c1f128e0
```

- List containers on the local system
```bash
bash:
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
7c0d7e6e5e6e        xilinx-vivado:v2019.1   "/bin/bash"         15 seconds ago      Up 14 seconds                           xilinx_vivado_v2019.1                         xilinx_vivado_v2018.3
```

- Verify the container is setup with the MAC address specified (for Vivado Licensing)
```bash
bash:
$ docker inspect xilinx_vivado_v2019.1 | grep MacAddress
            "MacAddress": "02:de:ad:be:ef:99",
            "MacAddress": "02:de:ad:be:ef:99",
                    "MacAddress": "02:de:ad:be:ef:99",
```


## Connect to the running container
- There are two common ways to interact with the container
	- use __*docker attach*__ to use the container interactively with a shell session
		- This method was used above to verify that the container was running
	- use __*docker exec*__ to execute commands in the container from the host OS command line

### Method #1: Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -d xilinx_vivado_v2019.1 bash -c "xterm" &
```

### Method #2: Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_vivado_v2019.1
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ xterm &
[1] 25
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$
```

## Setup the Vivado License in the running container

### Transfer the Vivado License to the running container
- The are two common ways to get the license file into the container
	- use a shared folder (such as __*/srv/shared*__) that is mounted during container run-time
	- use __*docker cp*__ to copy the license file into a docker container

#### Method #1: Access the License with a Shared Folder
- Use a shared folder (such as __*/srv/shared*__) that is mounted during container run-time
- From the host OS terminal, show which folders are mounted/shared in the container
```bash
bash:
$ docker inspect --format '{{range .Mounts}}{{println .Source .Destination}}{{end}}' xilinx_vivado_v2019.1
/srv/tftpboot /tftpboot
/srv/hardware_definitions /srv/hardware_definitions
/tmp/.X11-unix /tmp/.X11-unix
/srv/software/xilinx /srv/software
/srv/shared /srv/shared
/xilinx/local/sstate-mirrors /srv/sstate-mirrors
/xilinx/local/sstate-cache /srv/sstate-cache
/home/xilinx/.Xauthority /home/xilinx/.Xauthority
/xilinx/local/trds /srv/trds
```

- From an xterm session associated with the running container, verify you can see the license file on a shared drive
```bash
xterm:
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ ls -al /srv/shared/licenses
total 40
drwxrwxr-x 2 xilinx xilinx  4096 Nov 29 17:53 .
drwxr-xr-x 4 xilinx xilinx  4096 Nov 29 17:53 ..
-rw-rw-r-- 1 xilinx xilinx  1789 Feb  8 17:27 Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic
```

#### Method #2: Copy the License to the container from the host
- Use __*docker cp*__ to copy the license file into a docker container
- First, create a folder to hold the license file
```bash
bash:
$ docker exec -it xilinx_vivado_v2019.1 bash -c "mkdir -p /opt/Xilinx/licenses"
```

- Copy the license file from the host to the running docker container
```bash
bash:
$ docker cp /srv/shared/licenses/Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic xilinx_vivado_v2019.1:/opt/Xilinx/licenses
```

- List the container's folder contents from the host
```bash
bash:
$ docker exec -it xilinx_vivado_v2019.1 bash -c "ls -al /opt/Xilinx/licenses"
total 12
drwxr-xr-x 2 xilinx xilinx 4096 Jun 24 14:01 .
drwxr-xr-x 1 xilinx xilinx 4096 Jun 24 14:01 ..
-rw-r--r-- 1 xilinx xilinx 1789 Jun 24 14:01 Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic
```

### Launch Vivado in the container
- You can launch Vivado in the container in several ways...

#### Method #1: Use __*docker attach*__ to use the container interactively with a shell session
- Launch vivado directly from the attached terminal session

```bash
bash:
$ docker attach xilinx_vivado_v2019.1
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2019.1/bin/vivado
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ vivado

****** Vivado v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
  **** IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2a: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch an xterm session first, then launch Vivado from that

```bash
bash:
$ docker exec -d xilinx_vivado_v2019.1 bash -c "xterm" &
$
```

```bash
xterm:
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2019.1/bin/vivado
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ vivado

****** Vivado v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
  **** IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2b: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch Vivado directly without a terminal (downside is you can't see command line output)

```bash
bash:
$ docker exec -d xilinx_vivado_v2019.1 bash -c "/opt/Xilinx/Vivado/2019.1/bin/vivado"
```

### Setup the License in the Vivado Gui
 - From the Vivado GUI menu, select ```Help -> Manage License...```
 - Load the license file from __*/opt/Xilinx/licenses*__ or a shared folder (__*/srv/shared/licenses*__)

### Exit Vivado
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P><CTRL-Q>*__
```bash:
bash:
xilinx@xilinx_vivado_v2019.1:/opt/Xilinx$ read escape sequence
[1]+  Done                    docker exec -d xilinx_vivado_v2019.1 bash -c "xterm"
```
- The container should still be running, even if Vivado has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
7c0d7e6e5e6e        xilinx-vivado:v2019.1   "/bin/bash"         3 hours ago         Up 3 hours                              xilinx_vivado_v2019.1
$
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
$ docker stop xilinx_vivado_v2019.1
xilinx_vivado_v2019.1
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_vivado_v2019.1 xilinx-vivado-licensed:v2019.1
sha256:609aa98e800984ca49f181fbce11250426735c90e2ce8ec20da48aa972454cf0
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed   v2019.1             609aa98e8009        4 seconds ago       52.5GB
xilinx-vivado            v2019.1             0570aa89c8b9        12 hours ago        52.5GB
ubuntu                   18.04.1             4112b3ccf856        45 hours ago        83.5MB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xilinx-vivado-v2019.1_image_backup_licensed_02deadbeef99.tar xilinx-vivado-licensed:v2019.1
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xilinx-vivado-v2019.1*-rw------- 1 xilinx xilinx 52804712960 Jun 24 10:52 xilinx-vivado-v2019.1_image_backup_licensed_02deadbeef99.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-vivado-licensed:v2019.1 
Untagged: xilinx-vivado-licensed:v2019.1
Deleted: sha256:609aa98e800984ca49f181fbce11250426735c90e2ce8ec20da48aa972454cf0
Deleted: sha256:c4135f812fccdb72b9e71b47a5ad080180379334ee036d79d1078b3bc84f21fc
```

### Example: Restore a container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Vivado Tools installed and licensed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working Vivado environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xilinx-vivado-v2019.1_image_backup_licensed_02deadbeef99.tar
c3b2ee02139b: Loading layer [==================================================>]  193.5kB/193.5kB
Loaded image: xilinx-vivado-licensed:v2019.1
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed   v2019.1             609aa98e8009        33 minutes ago      52.5GB
xilinx-vivado            v2019.1             0570aa89c8b9        12 hours ago        52.5GB
ubuntu                   18.04.1             4112b3ccf856        46 hours ago        83.5MB

```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-vivado-licensed:v2019.1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
609aa98e8009        33 minutes ago      /bin/bash                                       154kB               
<missing>           12 hours ago        |11 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.14MB              
<missing>           12 hours ago        |11 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   50.5GB              
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_VIVADO_BATCH_CON…   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_VIVADO_OFFLINE_I…   0B                  
<missing>           13 hours ago        |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   3.17MB              
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           13 hours ago        |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   163MB               
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           13 hours ago        |7 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User@…   79B                 
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           13 hours ago        |5 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   1.37GB              
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           13 hours ago        |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   39.4MB              
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           13 hours ago        |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   39.2MB              
<missing>           13 hours ago        |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   276MB               
<missing>           13 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           13 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           46 hours ago                                                        83.5MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-vivado-licensed:v2019.1 xilinx_vivado_licensed_v2019.1 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado-licensed:v2019.1
DOCKER_CONTAINER_NAME: xilinx_vivado_licensed_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
access control disabled, clients can connect from any host
82002ddc214e71ad6bca7e7d8251ced9f6fd70d88a91ef66b5caa4eef5e75065
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Vivado Tools installed and licensed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-vivado-v2019.1_container_backup_licensed_02deadbeef99.tar xilinx_vivado_licensed_v2019.1
```

- Verify the new filesystem archive saved to your local machine
```bash
bash:
$ ls -al xlnx-vivado-v2019.1* 
-rw------- 1 rjmoss rjmoss 52095706112 Jun 24 11:20 xlnx-vivado-v2019.1_container_backup_licensed_02deadbeef99.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Vivado  Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-vivado-v2019.1_container_backup_licensed_02deadbeef99.tar xilinx-vivado-licensed-imported-container:v2019.1
sha256:1d0bd14a4116d2ae55ebd83d020748a8f2f20a003dc547df7a537393dc213531
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed-imported-container   v2019.1             1d0bd14a4116        36 seconds ago      51.8GB
xilinx-vivado-licensed                      v2019.1             609aa98e8009        About an hour ago   52.5GB
xilinx-vivado                               v2019.1             0570aa89c8b9        12 hours ago        52.5GB
ubuntu                                      18.04.1             4112b3ccf856        46 hours ago        83.5MB
xilinx-vivado-licensed-imported             v2018.3             8b500f7ccec9        50 seconds ago      42.7GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-vivado-licensed-imported-container:v2019.1 
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
1d0bd14a4116        About a minute ago                       51.8GB              Imported from -              
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh  xilinx-vivado-licensed-imported-container:v2019.1 xilinx_vivado_imported_licensed_v2019.1 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado-licensed-imported-container:v2019.1
DOCKER_CONTAINER_NAME: xilinx_vivado_imported_licensed_v2019.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
access control disabled, clients can connect from any host
83757c039e8e76677e9b5f85e701870c50df817a6ea580ba75d4a83918432db8
```
