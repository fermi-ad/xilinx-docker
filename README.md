# xilinx-docker

A collection of recipes and tools to enable Xilinx FPGA-based embedded development in docker containers.

Before getting started with any recipes, Take a look at the __*./documentation/host-os-setup/*__ section of this repository to make sure you have:
1. Installed and configured Docker-CE on your local host machine
2. Installed and configured any support packages (python, xterm, ...) that are used by this workflow in conjunction with Docker

## The use of each recipe follows this common workflow:

### The following tasks are performed one time to setup each recipe for automated image creation
- Any steps using a Xilinx Web Installer require a valid Xilinx account

1. Download the required Xilinx Web Installer binary file(s) directly from Xilinx
	- See each README file for required installer binaries
2. Place a link to this installer in the recipe's __*depends*__ folder
3. Build the required base os image for the recipe 
4. Generate the remaining required dependencies using each recipe's __**generate_depends*__ script
	- This script is interactive (requiring user input)
	- This script downloads additional required dependencies for each image
	- This script uses each Xilinx Web Installers to generate a batch installation configuration for each tool
		- This batch mode configuration allows "non-interactive" installation of each Xilinx tool
	- This script uses each Xilinx Web Installer to download an offline installation bundle for each tool
		- The offline installer allows "automated" installation of each Xilinx tool, easing re-creation of images
5. Create links to the generated dependencies in the __*depends*__ folder for each recipe
6. Copy generated configuration files to the __*configs*__ folder for each recipe

### Run each build script to generate a Docker image with Xilinx development tool(s) for each recipe

1. Run the __*build_image*__ script from the recipe folder to create a Docker image in the local repository
2. See the README file for each recipe to learn more about how to the resulting image

# Repository QuickStart Example
- Clone the remote repository
```bash
bash:
~$ mkdir ~/repos
~$ cd ~/repos
~/repos$ git clone https://gitlab.com/dxindustries/xilinx-docker.git
Cloning into 'xilinx-docker'...
remote: Enumerating objects: 457, done.
remote: Counting objects: 100% (457/457), done.
remote: Compressing objects: 100% (245/245), done.
remote: Total 457 (delta 208), reused 360 (delta 142)
Receiving objects: 100% (457/457), 297.01 KiB | 2.11 MiB/s, done.
Resolving deltas: 100% (208/208), done.
```

- Add the repository tools to your PATH
```bash
bash:
~/repos$ export PATH=$PATH:~/repos/xilinx-docker/tools/bash
```

- Verify that the repository tools are in your path
```bash
bash:
~/repos$ which run_image_x11_macaddr.sh
~/repos/xilinx-docker/tools/bash/run_image_x11_macaddr.sh
```

# Docker Image Quickstart Example

## One-time dependency generation for the target image
### 1) Download the required Xilinx Web Installer binary file(s) directly from Xilinx
- Example: Xilinx SDK v2018.3
- Read the README.md in each recipe subfolder for details on pre-requisites for each image recipe
- Download the Xilinx SDK v2018.3 Web Installer directly from Xilinx
	- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2018.3_1207_2324_Lin64.bin

### 2) Place a link to this installer in the recipe's __*depends*__ folder
- Example: Xilinx SDK v2018.3
- Create a link to the Xilinx SDK Installer in the dependencies folder
```bash
bash:
~/repos$ cd xilinx-docker/recipes/sdk/v2018.3/depends
~/repos/xilinx-docker/recipes/sdk/v2018.3/depends$ ln -s <path_to_downloaded_binary_from_xilinx>/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
~/repos/xilinx-docker/recipes/sdk/v2018.3/depends$ ls -al
total 16
drwxrwxr-x 2 xilinx xilinx 4096 Mar 15 21:57 .
drwxrwxr-x 6 xilinx xilinx 4096 Mar 15 21:24 ..
-rw-rw-r-- 1 xilinx xilinx  101 Mar 15 21:24 .gitignore
lrwxrwxrwx 1 xilinx xilinx   62 Mar 15 21:57 Xilinx_SDK_2018.3_1207_2324_Lin64.bin -> /srv/software/xilinx/sdk/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
```

### 3) Build the required base os image for the recipe
- Example: Xilinx SDK v2018.3
- Figure out what base image you need
```bash
bash:
~/repos/xilinx-docker/recipes/sdk/v2018.3/depends$ find ~/repos/xilinx-docker -name Dockerfile -exec grep 'FROM' {} \;
FROM ubuntu:16.04.3 AS base_os_yocto_v2018.3
...
FROM ubuntu:16.04.3 AS base_os_xsdk_v2018.3
...
FROM ubuntu:18.04.2 AS base_os_vivado_v2018.3
...
FROM ubuntu:16.04.3 AS base_os_petalinux_v2018.3
...
```

- The __*base image*__ for the Xilinx SDK is Ubuntu 16.04.3
- Create the base image for the Xilinx SDK v2018.3
```bash
bash:
~/repos/xilinx-docker/recipes/sdk/v2018.3/depends$ cd ../../../base-image/ubuntu-16.04.3
~/repos/xilinx-docker/base-image/ubuntu-16.04.3$ ./build_image.sh
Base Release Image [Missing] ubuntu-base-16.04.3-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.3/release/ubuntu-base-16.04.3-base-amd64.tar.gz
...
Base Relese Image Download [Good] ubuntu-base-16.04.3-base-amd64.tar.gz
...
REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
ubuntu              16.04.3             9f7da40b2e32        Less than a second ago   120MB
...
```

### 4) Generate the remaining required dependencies using each recipe's __**generate_depends*__ script
- Example: Xilinx SDK v2018.3
- Read the README.md in the recipe subfolder for details on pre-requisites for each image recipe
- Generate additional required dependencies
- Create the Xilinx tool image (Example: Xilinx SDK v2018.3)
```bash
bash:
~/repos/xilinx-docker/base-image/ubuntu-16.04.3$ cd ../../sdk/v2018.3/
~/repos/xilinx-docker/sdk/v2018.3$ ./generate_depends.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:16.04.3)
Xilinx SDK Web Installer: [Exists] depends/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
-----------------------------------
Docker Build Context (Working)...
-----------------------------------
...
-----------------------------------
Generating Xilinx Keyboard Configuration... (Interactive)
-----------------------------------
```

- Select the keyboard configuration (outlined in the README file for the recipe)
- Keyboard configuration
	- Select a keyboard model: ```Generic 105-key (Intl) PC``` is the default
	- Select a country of origin for the keyboard: ```English (US)``` is the default
	- Select a keyboard layout: ```English (US)``` is the default
	- Select an AltGr function: ```The default for the keyboard layout``` is the default
	- Select a compose key: ```No compose key``` is the default

```bash
bash:
...
-----------------------------------
Copying keyboard configuration to host...
-----------------------------------
...
-----------------------------------
Building Offline SDK Installer Bundle...
-----------------------------------
 - Install dependencies and download SDK installer into container...
-----------------------------------
...
-----------------------------------
 - Extract the SDK Installer and generate a batch mode config...
-----------------------------------
...
Running in batch mode...
Copyright (c) 1986-2019 Xilinx, Inc.  All rights reserved.
INFO : Log file location - /root/.Xilinx/xinstall/xinstall_1552662276886.log
1. Xilinx Software Development Kit (XSDK)
2. Xilinx Software Command-Line Tool (XSCT)
3. Xilinx BootGen Kit (BootGen)

Please choose:
```

- Select the desired tool batch mode configuration
- Xilinx SDK batch mode configuration (generate)
	- Select Xilinx Software Development Kit (XSDK): option ```1```

```bash
bash:
INFO : Config file available at /root/.Xilinx/install_config.txt. Please use -c <filename> to point to this install configuration.
+ cd /home/xilinx/downloads/tmp
+ mkdir -p configs
+ cp /root/.Xilinx/install_config.txt configs/xsdk_config_xsdk_full.config
+ vi configs/xsdk_config_xsdk_full.config
```

- A __*vim*__ editor session will open the batch mode configuration file
- Change the Xilinx SDK batch mode configuration
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```InstallOptions=Enable WebTalk for SDK to send usage statistics to Xilinx:0```
		- ```CreateProgramGroupShortcuts=1```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=0```
	- Save with ```:wq```

```bash
bash:
...
-----------------------------------
Copying Xilinx SDK batch mode configurations to host ...
-----------------------------------
...
-----------------------------------
 - Launch SDK Setup to create a download bundle...
-----------------------------------
...
```

- An XTerm session will launch to download the full installation bundle that matches the batch mode configuration
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

```bash
bash:
...
-----------------------------------
Copying Xilinx SDK offline installer to host ...
-----------------------------------
...
-----------------------------------
Dependency Generation Complete
-----------------------------------
STARTED :Fri Mar 15 11:02:57 EDT 2019
ENDED   :Fri Mar 15 11:09:11 EDT 2019
-----------------------------------
DOCKER_FILE_NAME=Dockerfile
DOCKER_FILE_STAGE=base_os_xsdk_v2018.3
DOCKER_IMAGE=dependency_generation:v2018.3
DOCKER_CONTAINER_NAME=build_xsdk_depends_v2018.3
-----------------------------------
Dependencies Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1553 Mar 15 11:03 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1245 Mar 15 11:05 _generated/configs/xsdk_config_xsdk_full.config
-rw-r--r-- 1 xilinx xilinx 1373658763 Mar 15 11:09 _generated/depends/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz\
```

### 5) Create links to the generated dependencies in the __*depends*__ folder for each recipe
- Example: Xilinx SDK v2018.3

```bash
bash:
~/repos/xilinx-docker/sdk/v2018.3$ cd depends
~/repos/xilinx-docker/sdk/v2018.3/depends$ ln -s ../_generated/depends/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz
~/repos/xilinx-docker/sdk/v2018.3/depends$ ls -l
total 20
drwxrwxr-x 2 xilinx xilinx 4096 Mar 15 14:36 .
drwxrwxr-x 7 xilinx xilinx 4096 Mar 15 14:39 ..
-rw-rw-r-- 1 xilinx xilinx  101 Mar 15 14:36 .gitignore
lrwxrwxrwx 1 xilinx xilinx   62 Mar 15 10:52 Xilinx_SDK_2018.3_1207_2324_Lin64.bin -> /srv/software/xilinx/sdk/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
lrwxrwxrwx 1 xilinx xilinx   84 Mar 15 11:21 Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz -> /srv/software/xilinx/sdk/offline_installers/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz
```

### 6) Copy generated configuration files to the __*configs*__ folder for each recipe
- Example: Xilinx SDK v2018.3

```bash
bash:
~/repos/xilinx-docker/sdk/v2018.3/depends$ cd ../configs
~/repos/xilinx-docker/sdk/v2018.3/configs$ cp ../_generated/configs/* .
~/repos/xilinx-docker/sdk/v2018.3/configs$ ls -l
total 12
-rw-rw-r-- 1 xilinx xilinx 1553 Mar 15 14:36 keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1245 Mar 15 11:21 xsdk_config_xsdk_full.config
-rw-rw-r-- 1 xilinx xilinx  227 Mar 15 14:36 XTerm
```

## Run the build script to generate the Docker image with the Xilinx development tool(s) for the recipe
### 1) Run the __*build_image*__ script from the recipe folder to create a Docker image in the local repository
- Example: Xilinx SDK v2018.3
- Execute the build script

```bash
bash:
~/repos/xilinx-docker/sdk/v2018.3/configs$ cd ..
~/repos/xilinx-docker/sdk/v2018.3$ ./build_image.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:16.04.3)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
Xilinx XSDK WEB Installer: [Good] depends/Xilinx_SDK_2018.3_1207_2324_Lin64.bin
Xilinx XSDK Offline Installer: [Good] depends/Xilinx_SDK_2018.3_1207_2324_Lin64.tar.gz
XTerm Configuration File: [Good] configs/XTerm
-----------------------------------
Docker Build Context (Working)...
-----------------------------------
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

### 2) See the README file for each recipe to learn more about how to the resulting image
- Example: Xilinx SDK v2018.3
- See the README.md file for the Xilinx SDK recipe
- Things to do:
	- Create a working container
	- Connect to the container (Attach)
	- Launch an xterm session in the container
	- Properly detach from a container (leaving it running in the background)
	- Backup and Restore an image or running container

