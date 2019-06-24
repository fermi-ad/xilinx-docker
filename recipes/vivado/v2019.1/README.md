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
-rw-r--r-- 1 rjmoss rjmoss 1554 Jun 23 01:08 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 rjmoss rjmoss 1873 Jun 23 01:11 _generated/configs/xlnx_vivado_system_edition.config
-rw-r--r-- 1 rjmoss rjmoss 24248813183 Jun 23 02:13 _generated/depends/
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

<---------------- RESUME EDITS HERE ------------------->
<---------------- RESUME EDITS HERE ------------------->
<---------------- RESUME EDITS HERE ------------------->
<---------------- RESUME EDITS HERE ------------------->
<---------------- RESUME EDITS HERE ------------------->

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

```

## Create a working container (running in daemon mode) based on the vivado image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress

- List local docker images
```bash
bash:
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado       v2018.3             9682fb401a2a        22 minutes ago      43.3GB
ubuntu              18.04.2             0c174d761a30        24 hours ago        88.3MB
```

- Use the included tool script to create a Container based on the Vivado image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-vivado:v2018.3 xilinx_vivado_v2018.3 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado:v2018.3
DOCKER_CONTAINER_NAME: xilinx_vivado_v2018.3
DOCKER_CONTAINER_MACADDR: 
access control disabled, clients can connect from any host
4c5ae631bb27568a5a2d346cafdb4b6ece7224f0d067d182d88be6cd8b1c630b
```

- List containers on the local system
```bash
bash:
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
4c5ae631bb27        xilinx-vivado:v2018.3   "/bin/bash"         32 seconds ago      Up 31 seconds                           xilinx_vivado_v2018.3
```

- Verify the container is setup with the MAC address specified (for Vivado Licensing)
```bash
bash:
$ docker inspect xilinx_vivado_v2018.3 | grep MacAddress
            "MacAddress": "02:de:ad:be:ef:99",
            "MacAddress": "02:de:ad:be:ef:99",
                    "MacAddress": "02:de:ad:be:ef:99",
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
$ docker exec -d xilinx_vivado_v2018.3 bash -c "xterm" &
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_vivado_v2018
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ xterm &
[1] 25
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$
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
$ docker inspect --format '{{range .Mounts}}{{println .Source .Destination}}{{end}}' xilinx_vivado_v2018.3
/tmp/.X11-unix /tmp/.X11-unix
/home/xilinx/.Xauthority /home/xilinx/.Xauthority
/srv/sstate-mirrors /srv/sstate-mirrors
/srv/sstate-cache /srv/sstate-cache
/srv/tftpboot /tftpboot
/srv/software/xilinx /srv/software
/srv/hardware_definitions /srv/hardware_definitions
/srv/shared /srv/shared
$
```

- From an xterm session associated with the running container, verify you can see the license file on a shared drive
```bash
xterm:
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ ls -al /srv/shared/licenses
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
$ docker exec -it xilinx_vivado_v2018.3 bash -c "mkdir -p /opt/Xilinx/licenses"
```

- Copy the license file from the host to the running docker container
```bash
bash:
$ docker cp /srv/shared/licenses/Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic xilinx_vivado_v2018.3:/opt/Xilinx/licenses
```

- List the container's folder contents from the host
```bash
bash:
$ docker exec -it xilinx_vivado_v2018 bash -c "ls -al /opt/Xilinx/licenses"
total 40
drwxr-xr-x 2 xilinx xilinx  4096 Nov 29 18:14 .
drwxr-xr-x 1 xilinx xilinx  4096 Nov 29 18:13 ..
-rw-rw-r-- 1 xilinx xilinx  1789 Feb  8 17:27 Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic
```

### Launch Vivado in the container
- You can launch Vivado in the container in several ways...

#### Method #1: Use __*docker attach*__ to use the container interactively with a shell session
- Launch vivado directly from the attached terminal session

```bash
bash:
$ docker attach xilinx_vivado_v2018
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2018.3/bin/vivado
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ vivado

****** Vivado v2018.3 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
  **** IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2a: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch an xterm session first, then launch Vivado from that

```bash
bash:
$ docker exec -d xilinx_vivado_v2018.3 bash -c "xterm" &
$
```

```bash
xterm:
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2018.3/bin/vivado
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$ vivado

****** Vivado v2018.3 (64-bit)
  **** SW Build 2258646 on Thu Jun 14 20:02:38 MDT 2018
  **** IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2b: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch Vivado directly without a terminal (downside is you can't see command line output)

```bash
bash:
$ docker exec -d xilinx_vivado_v2018.3 bash -c "/opt/Xilinx/Vivado/2018.3/bin/vivado"
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
xilinx@xilinx_vivado_v2018.3:/opt/Xilinx$$ read escape sequence
[1]+  Done                    docker exec -d xilinx_vivado_v2018.3 bash -c "xterm"
```
- The container should still be running, even if Vivado has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
4c5ae631bb27        xilinx-vivado:v2018.3   "/bin/bash"         26 minutes ago      Up 26 minutes                           xilinx_vivado_v2018.3
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
$ docker stop xilinx_vivado_v2018.3
xilinx_vivado_v2018.3
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_vivado_v2018.3 xilinx-vivado-licensed:v2018.3
sha256:72921a63caebd4406a4f25b4c816e4ef64816ebdccc3504ccec5048bfccf7628
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed   v2018.3             72921a63caeb        28 seconds ago      43.3GB
xilinx-vivado            v2018.3             9682fb401a2a        8 hours ago         43.3GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-vivado-v2018.3_image_backup_licensed_02deadbeef99.tar xilinx-vivado-licensed:v2018.3
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xlnx-vivado-v2018.3*
-rw------- 1 xilinx xilinx 43454688256 Feb 27 20:21 xlnx-vivado-v2018.3_image_backup_licensed_02deadbeef99.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-vivado-licensed:v2018.3
Untagged: xilinx-vivado-licensed:v2018.3
Deleted: sha256:72921a63caebd4406a4f25b4c816e4ef64816ebdccc3504ccec5048bfccf7628
Deleted: sha256:09194595939252613c12cc20680cc48b279f93f2bad59fdcf885aa4396bea8d2
```

### Example: Restore a container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Vivado Tools installed and licensed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working Vivado environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-vivado-v2018.3_container_backup_licensed_02deadbeef99.tar
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed            v2018.3             72921a63caeb        41 hours ago        43.3GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-vivado-licensed:v2018.3
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
72921a63caeb        41 hours ago        /bin/bash                                       91.5kB              
<missing>           2 days ago          |11 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.14MB              
<missing>           2 days ago          |11 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   41.8GB              
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_VIVADO_BATCH_CON…   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_VIVADO_OFFLINE_I…   0B                  
<missing>           2 days ago          |9 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   3.16MB              
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           2 days ago          |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   30.9MB              
<missing>           2 days ago          /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           2 days ago          |7 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User@…   79B                 
<missing>           2 days ago          /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           2 days ago          |5 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   1.06GB              
<missing>           2 days ago          /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           2 days ago          |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   38.3MB              
<missing>           2 days ago          /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           2 days ago          |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   37.6MB              
<missing>           2 days ago          |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   254MB               
<missing>           2 days ago          /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           2 days ago          /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           3 days ago                                                          88.3MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh  xilinx-vivado-licensed:v2018.3 xilinx_vivado_loaded_licensed_v2018.3 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado-licensed:v2018.3
DOCKER_CONTAINER_NAME: xilinx_vivado_loaded_licensed_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
access control disabled, clients can connect from any host
c75206901573880b92a05eb86f83d2bee334d0051a00bafac50677f9806b117f
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Vivado Tools installed and licensed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-vivado-v2018.3_container_backup_licensed_02deadbeef99.tar xilinx_vivado_loaded_licensed_v2018.3
```

- Verify the new filesystem archive saved to your local machine
```bash
bash:
$ ls -al xlnx-vivado-v2018.3*
-rw------- 1 xilinx xilinx 42831595008 Mar  1 13:27 xlnx-vivado-v2018.3_container_backup_licensed_02deadbeef99.tar
-rw------- 1 xilinx xilinx 43454688256 Feb 27 20:21 xlnx-vivado-v2018.3_image_backup_licensed_02deadbeef99.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Vivado  Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-vivado-v2018.3_container_backup_licensed_02deadbeef99.tar xilinx-vivado-licensed-imported-container:v2018.3
sha256:8b500f7ccec99dc751f38fb25670dc5ab8acce66419cd462e8ef336b9466a6d5
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
xilinx-vivado-licensed-imported             v2018.3             8b500f7ccec9        50 seconds ago      42.7GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-vivado-licensed-imported:v2018.3
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
8b500f7ccec9        About a minute ago                       42.7GB              Imported from -                 
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh  xilinx-vivado-licensed-imported:v2018.3 xilinx_vivado_imported_licensed_v2018.3 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado-licensed-imported:v2018.3
DOCKER_CONTAINER_NAME: xilinx_vivado_imported_licensed_v2018.3
DOCKER_CONTAINER_MACADDR: 
access control disabled, clients can connect from any host
ec4c1e79da765dfc0aa1e12d5e7516522d59a2da7499311c616997e90a6f286a
```
