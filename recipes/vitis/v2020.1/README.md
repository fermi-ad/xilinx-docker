[//]: # (README.md - Vitis v2020.1 Build Environment)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> host_xrt_setup.sh
-> Dockerfile
-> configs/
	-> keyboard_settings.conf
	-> xlnx_unified_vitis.config
	-> XTerm
-> depends/
	-> Xilinx_Unified_2020.1_0602_1208_Lin64.bin
	-> (Vitis_Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz)
	-> xrt_202010.2.6.655_18.04-amd64-xrt.deb
-> include/
	-> configuration.sh
```

< -- Update From Here --> 

# Setup Host System for XRT
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf
```bash
$ wget -nv https://raw.githubusercontent.com/Xilinx/XRT/2020.1/src/runtime_src/tools/scripts/xrtdeps.sh -O depends/xrtdeps.sh
```

# Need to determine XRT dependencies?
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/html_docs/accelerator_cards/alveo_doc_280/dwt1537506874594.html

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx Unified Web Installer.
	- Xilinx Unified Installer v2020.1
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2020.1_0602_1208_Lin64.bin
		- Documentation:
			- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/index.html
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2020.1 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2020_1/vitis_doc/wlk1553469789555.html


## Download the Xilinx Runtime (XRT)
- The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
	- Pre-built XRT Ubuntu 18.04 Package for v2020.1
		- Installation Instructions:
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug1451-xrt-release-notes.pdf
		- Download Link:
			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_202010.2.6.655_18.04-amd64-xrt.deb

### Reference - Building XRT from Source
- XRT can be built form source as an option
	- Instructions v2020.1:
		- https://xilinx.github.io/XRT/2020.1/html/index.html

## Setting the Host IP Address
- Currently the build scripts pull the correct host IP address from the system, so there is no need to set this manually.

### Locate the local ipaddress
- For Linux use __ifconfig__ to determine the host IP address
- For Windows Powershell use __ipconfig__ to determine the host IP address

## To Generate a base Ubuntu 18.04.2 image (one time)
- For Linux, execute the image generation script __*../../base-images/ubuntu_18.04.2/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-18.04.2
$ ./build_image.sh 
Base Release Image [Missing] ubuntu-base-18.04.2-base-amd64.tar.gz
Attempting to download http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
+ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz -O depends/ubuntu-base-18.04.2-base-amd64.tar.gz
--2019-12-18 10:20:17--  http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.2/release/ubuntu-base-18.04.2-base-amd64.tar.gz
Resolving cdimage.ubuntu.com (cdimage.ubuntu.com)... 2001:67c:1360:8001::28, 2001:67c:1360:8001::27, 2001:67c:1560:8001::1d, ...
Connecting to cdimage.ubuntu.com (cdimage.ubuntu.com)|2001:67c:1360:8001::28|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 31858560 (30M) [application/x-gzip]
Saving to: ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’

depends/ubuntu-base-18.04.2-base-amd64.tar.gz            100%[=================================================================================================================================>]  30.38M  18.9MB/s    in 1.6s    

2019-12-18 10:20:18 (18.9 MB/s) - ‘depends/ubuntu-base-18.04.2-base-amd64.tar.gz’ saved [31858560/31858560]

+ '[' 1 -ne 0 ']'
+ set +x
Base Relese Image Download [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.2-base-amd64.tar.gz ubuntu:18.04.2
sha256:1c767f5d46fef0b75f5a1ab0f971b79f5fe3343f90c2861842713c6be7cf2a46
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.2              1c767f5d46fe        Less than a second ago   88.3MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   88.3MB              0B (0%)
Containers          0                   0                   0B            	 	0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x
```

## Generate Vitis Image Install Dependencies (one time)

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

- Xilinx Unified batch mode configuration (generate)
	- Select Vitis Unified Software Platform: option ```1```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=0```
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
	- Create the download directory (in the container) when prompted: ```Yes```
	- Select the product to install
		- ```Vitis```
		- Continue: ```Next```
	- Select edition to install
		- ```Vitis Unified Software Platform```
	- Futher configure the installation:
		- Design Tools
			- Uncheck DocNav
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/v2020.1```
		- Disk Space Required:
			- ```Download Size: 30.1GB```
			- ```Disk Space Required: 30.1GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated dependencies

```bash
bash:
-----------------------------------
Dependencies Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1554 Jul  3 09:47 _generated/configs/keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1797 Jul  3 09:57 _generated/configs/xlnx_unified_vitis.config
-rw-r--r-- 1 xilinx xilinx 32461871729 Jul  3 11:20 _generated/depends/Xilinx_Unified_2020.1_0602_1208_Lin64.bin.tar.gz
-----------------------------------

```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2020.1 Vitis Image (one time)

### Configure build options
- For Linux Hosts:
	- Modify build options in the file __*./include/configuration.sh*__
- For Windows Hosts:
	- Modify build options in the file __*./include/configuration.ps1*__

### Execute the image build script
- Note: The build error is expected Build times reflected below were on an HP ZBook 15 G3, on battery power, connected to a WiFi 4G Hotspot
```bash
bash:
$ ./build_image.sh
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
Xilinx Unified Web Installer: [Good] depends/Xilinx_Unified_2020.1_1024_1831_Lin64.bin
Xilinx Unified Offline Installer: [Good] depends/Xilinx_Unified_2020.1_1024_1831_Lin64.bin.tar.gz
XTerm Configuration File: [Good] configs/XTerm
-----------------------------------

...

-----------------------------------
Image Build Complete...
STARTED :Sun Dec 22 21:58:53 EST 2019
ENDED   :Sun Dec 22 23:09:23 EST 2019
-----------------------------------
```

## Create a working container (running in daemon mode) based on the vitis image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress

- List local docker images
```bash
bash:
$ docker image ls
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
xilinx-vitis             v2020.1             d0113786a6eb        14 minutes ago      93.7GB
ubuntu                   18.04.1             4112b3ccf856        42 hours ago        83.5MB
```

< ---- RESUME README UPDATES HERE --->



- Test ZCU104 DPU Examples
- https://github.com/Xilinx/Vitis-AI/blob/master/mpsoc/README.md
