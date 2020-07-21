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

## Need to determine Vivado dependencies?
### Download ldd-recursive.pl
https://downloads.sourceforge.net/project/recursive-ldd/ldd-recursive.pl?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Frecursive-ldd%2Ffiles%2Flatest%2Fdownload&ts=1537542905

### Run the ldd-recursive.pl script on the Vivado executable
```bash
bash:
$ perl ldd-recursive.pl /opt/Xilinx/Vivado/2019.2/bin/unwrapped/lnx64.o/vivado -uniq
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

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address

## Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__

## Generate a base Ubuntu 18.04.1 image (one time)
- For Linux, execute the base image generation script __*../../base-images/ubuntu_18.04.1/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-18.04.1/
$ ./build_image.sh 
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

$ popd
```

## Generate an Ubuntu 18.04.1 user image (one time)
- Execute the image generation script __*../../../user-images/v2019.1/ubuntu-18.04.1-user/build_image.sh*__
```bash
$ pushd ../../../user-images/v2019.2/ubuntu-18.04.2-user/
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.1)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container 344af33a95f3
 ---> 469af6a10c38
Successfully built 469af6a10c38
Successfully tagged xilinx-ubuntu-18.04.1-user:v2019.1
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 16058
-----------------------------------
+ kill 16058
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 16058 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Fri Jul 17 21:08:30 EDT 2020
ENDED   :Fri Jul 17 21:14:05 EDT 2020
-----------------------------------

$ popd
```

## Generate Vivado Image Install Configuration Files (one time)

Note: Disk use optimization doesn't run unless both ```CreateFileAssociation=1``` and ```EnableDiskUsageOptimization=1``` are set in the configuration

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)

- Xilinx Vivadobatch mode configuration (generate)
	- Select ```Vivado HL System Edition```: option ```3```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```Modules=...DocNav:0,...``` 
		- ```InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0,Enable WebTalk for Vivado to send usage statistics to Xilinx (Always enabled for WebPACK license):0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=1```
		- ```EnableDiskUsageOptimization=1```
	- Save with ```:wq```

- Review the generated configurations

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1873 Jul 20 12:21 _generated/configs/xlnx_vivado.config
-----------------------------------

```

- Copy the generated configurations to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate Vivado Offline Installer Bundle (one time)

### Execute the installer generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_installer.sh
```

- Xilinx Vivado Installer (download only)
	- This should launch an X11-based Xilinx Vivado Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Image (Install Separately)```
		- Use the following selections:
			- download directory: ```/opt/Xilinx/Downloads/v2019.1```
			- download files to create full image for selected platform(s): ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2019.2```
		- Disk Space Required:
			- ```Download Size: 22.46GB```
			- ```Disk Space Required: 22.46GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated installer bundle

```bash
bash:
-----------------------------------
Xilinx offline installer generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 
-----------------------------------

```

- Create a link to the offline installer in the dependency folder

```bash
bash:
$ ln -s ../_generated/depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz depends/
```

# Build a v2019.1 Vivado Image (one time)

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
...
Successfully built 61754051c3d7
Successfully tagged xilinx-vivado:v2019.1
...
-----------------------------------
Image Build Complete...
STARTED :Mon Jul 20 21:11:37 EDT 2020
ENDED   :Mon Jul 20 21:37:52 EDT 2020
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
xilinx-vivado                    v2019.1              61754051c3d7        24 minutes ago      35.2GB
xilinx-ubuntu-18.04.1-user       v2019.1              469af6a10c38        3 days ago          2.02GB
ubuntu                           18.04.1              1f5eefc33d49        3 days ago          83.5MB

```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_vivado_v2019.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_vivado_v2019-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-vivado:v2019.1 \
	/bin/bash
f7069f57e62d483e6e9786d178aedbdbc23e3e953bcf268b6320b2ea7e995d76
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
f7069f57e62d        xilinx-vivado:v2019.1   "/bin/bash"         10 seconds ago      Up 8 seconds                            xilinx_vivado_v2019.1
```

## Connect to the running container

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_vivado_v2019.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Vivado settings script
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/$
```

## Execute Vivado Tools
- Launch Vivado from the working container
```bash
xterm:
xilinx@xilinx_vivado_v2019-1:/opt/Xilinx$ vivado

****** Vivado v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
  **** IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

start_gui
```
