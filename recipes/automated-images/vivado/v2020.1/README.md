[//]: # (README.md - Vivado v2020.1 Build Environment)

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
	-> Xilinx_Unified_2020.1_0602_1208_Lin64.bin
	-> (Vivado_Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz)
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
$ perl ldd-recursive.pl /opt/Xilinx/Vivado/2020.1/bin/unwrapped/lnx64.o/vivado -uniq
```

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Vivado Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Unified Installer v2020.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Unified_2020.1_1024_1831_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder

## Download the MALI Userspace Binaries
- Xilinx requires a valid xilinx.com account in order to download the MALI Userspace Binaries.
	- MALI Userspace Binaries for v2020.1 and earlier (used with v2020.1)
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
		- ```EnableDiskUsageOptimization=1```
	- Save with ```:wq```

- Xilinx Unified Installer (download only)
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Image (Install Separately)```
		- Use the following selections:
			- download directory: ```/opt/Xilinx/Downloads/v2020.1```
			- download files to create full image for selected platform(s): ```Linux```
			- image contents: ```Selected Product Only```
	- Continue: ```Next```
	- Select the product to install
		- ```Vivado```
		- Continue: ```Next```
	- Select edition to install
		- ```Vivado HL System Edition```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Select Product to Install: ```Vivado```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2020.1```
		- Disk Space Required:
			- ```Download Size: 26.19 GB```
			- ```Disk Space Required: 26.19 GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1554 Jun 26 06:26 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1829 Jun 26 06:30 _generated/configs/xlnx_vivado_system_edition.config
-rw-r--r-- 1 xilinx xilinx 28255017784 Jun 26 07:12 _generated/depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz

```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```
## Build a v2020.1 Vivado Image (one time)

### Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
- Note: Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
Xilinx MALI Binaries: [Good] depends/mali-400-userspace.tar
Xilinx Vivado Web Installer: [Good] depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin
Xilinx Vivado Offline Installer: [Good] depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

-----------------------------------
Image Build Complete...
STARTED :Fri Jun 26 08:48:23 EDT 2020
ENDED   :Fri Jun 26 09:37:14 EDT 2020
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
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-vivado                    v2020.1              640840eb3b4e        About an hour ago   64GB
ubuntu                           18.04.2              76df73440f9c        2 days ago          88.3MB
```

- Use the included tool script to create a Container based on the Vivado image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-vivado:v2020.1 xilinx_vivado_v2020.1 02:de:ad:be:ef:99
DOCKER_IMAGE_NAME: xilinx-vivado:v2020.1
DOCKER_CONTAINER_NAME: xilinx_vivado_v2020.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
28c752bd97f8d9c7482a1993e43177b97e65e83061e9a6d2d4b0f1f3402a068c
```

- List containers on the local system
```bash
bash:
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
28c752bd97f8        xilinx-vivado:v2020.1   "/bin/bash"         30 seconds ago      Up 28 seconds                           xilinx_vivado_v2020.1
```

- Verify the container is setup with the MAC address specified (for Vivado Licensing)
```bash
bash:
$ docker inspect xilinx_vivado_v2020.1 | grep MacAddress
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
$ docker exec -d xilinx_vivado_v2020.1 bash -c "xterm" &
```

### Method #2: Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_vivado_v2020.1
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ xterm &
[1] 25
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$
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
$ docker inspect --format '{{range .Mounts}}{{println .Source .Destination}}{{end}}' xilinx_vivado_v2020.1
/xilinx/local/trds /srv/trds
/tmp/.X11-unix /tmp/.X11-unix
/srv/shared /srv/shared
/xilinx/local/sstate-mirrors /srv/sstate-mirrors
/xilinx/local/sstate-cache /srv/sstate-cache
/srv/tftpboot /tftpboot
/srv/software/xilinx /srv/software
/home/yourusername/.Xauthority /home/xilinx/.Xauthority
/srv/hardware_definitions /srv/hardware_definitions
```

- From an xterm session associated with the running container, verify you can see the license file on a shared drive
```bash
xterm:
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ ls -al /srv/shared/licenses
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
$ docker exec -it xilinx_vivado_v2020.1 bash -c "mkdir -p /opt/Xilinx/licenses"
```

- Copy the license file from the host to the running docker container
```bash
bash:
$ docker cp /srv/shared/licenses/Xilinx.lic.vivado_system_edition_ubuntu_docker_02deadbeef99.lic xilinx_vivado_v2020.1:/opt/Xilinx/licenses
```

- List the container's folder contents from the host
```bash
bash:
$ docker exec -it xilinx_vivado_v2020.1 bash -c "ls -al /opt/Xilinx/licenses"
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
$ docker attach xilinx_vivado_v2020.1
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2020.1/bin/vivado
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ vivado

****** Vivado v2020.1 (64-bit)
  **** SW Build 2700185 on Thu Oct 24 18:45:48 MDT 2019
  **** IP Build 2699827 on Thu Oct 24 21:16:38 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2a: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch an xterm session first, then launch Vivado from that

```bash
bash:
$ docker exec -d xilinx_vivado_v2020.1 bash -c "xterm" &
$
```

```bash
xterm:
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ which vivado
/opt/Xilinx/Vivado/2020.1/bin/vivado
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ vivado

****** Vivado v2020.1 (64-bit)
  **** SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
  **** IP Build 2902112 on Wed May 27 22:43:36 MDT 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

start_gui
```

#### Method #2b: Use __*docker exec*__ to execute commands in the container from the host OS command line
- Launch Vivado directly without a terminal (downside is you can't see command line output)

```bash
bash:
$ docker exec -d xilinx_vivado_v2020.1 bash -c "/opt/Xilinx/Vivado/2020.1/bin/vivado"
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
xilinx@xilinx_vivado_v2020.1:/opt/Xilinx$ read escape sequence
[1]+  Done                    docker exec -d xilinx_vivado_v2020.1 bash -c "xterm"
```
- The container should still be running, even if Vivado has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
f19f128e8064        xilinx-vivado:v2020.1   "/bin/bash"         23 minutes ago      Up 23 minutes                           xilinx_vivado_v2020.1
$
```

# Backup and Sharing of Working Containers and Images
- See common example documentation for [Backup and Sharing of Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
