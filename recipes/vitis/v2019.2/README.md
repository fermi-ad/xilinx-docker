[//]: # (README.md - Vitis v2019.2 Build Environment)

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
	-> Xilinx_Unified_2019.2_1024_1831_Lin64.bin
	-> (Vitis_Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz)
	-> xrt_201920.2.3.1301_18.04-xrt.deb
-> include/
	-> configuration.sh
```
# Setup Host System for XRT
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf
```bash
$ wget -nv https://raw.githubusercontent.com/Xilinx/XRT/2019.2/src/runtime_src/tools/scripts/xrtdeps.sh -O depends/xrtdeps.sh
```

# Need to determine XRT dependencies?
## Download xrtdeps.sh shell script
- Package dependencies are listed in the shell script
https://github.com/Xilinx/XRT/blob/master/src/runtime_src/tools/scripts/xrtdeps.sh
- See UG1301 Getting Started Guide Alveo Accelerator Cards
	- https://www.xilinx.com/support/documentation/boards_and_kits/accelerator-cards/ug1301-getting-started-guide-alveo-accelerator-cards.pdf

# Quickstart
## Download Xilinx Public Signing Key
- As of 2018.2 Xilinx signs all packages and provides public key for verification of packages.
- Download Link:
	- https://www.xilinx.com/support/download/2019-2/xilinx-master-signing-key.asc
- Place the signing key (or a link to it) in the ./depends folder

## Download Xilinx Unified Web Installer
- Xilinx requires a valid xilinx.com account in order to download the Xilinx SDK Web Installer.
	- Xilinx Unified Installer v2019.2
		- Download Link: 
			- https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2019.2_1106_2127_Lin64.bin
		- Release Notes;
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2019-2.html
			- https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug973-vivado-release-notes-install-license.pdf
- Place the installer binary (or a link to it) in the ./depends folder
- Vitis v2019.2 Release Notes:
	- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk300137739.html


## Download the Xilinx Runtime (XRT)
- The Xilinx Runtime provides a software interface to Xilinx programmable logic devices.
	- Pre-built XRT Ubuntu 18.04 Package for v2019.2
		- Installation Instructions:
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#pjr1542153622642
		- Download Link:
			- https://www.xilinx.com/bin/public/openDownload?filename=xrt_201920.2.3.1301_18.04-xrt.deb

### Reference - Building XRT from Source
- XRT can be built form source as an option
	- Instructions v2019.2:
		- https://xilinx.github.io/XRT/2019.2/html/index.html

## Download the Alveo Data Center Accelerator Card Target Platforms (optional)
- Alveo Datacenter accelerator cards have pre-built packages available:
	- Pre-built Alveo Data Center Accelerator Card Packages
		- Installation Instructions
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#uxq1573167801088
		- Download Links:
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/device-models.html
				- Alveo Accelerator Card Downloads (drop-down menu)

## Download the Embedded Platform Targets (optional)
- Embedded Development platforms have pre-built packages available.
	- Pre-built Embedded Edge Platform packages
		- Installation Instructions: 
			- https://www.xilinx.com/html_docs/xilinx2019_2/vitis_doc/Chunk1674708719.html#rvu1542160683426
		- Download Links: 
			- https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/edge-platforms.html

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
	- Select Vivado HL System Edition: option ```3```
	- The configuration opens in the ```vim``` editor
	- Make the following modifications:
		- ```InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0,Enable WebTalk for Vivado to send usage statistics to Xilinx (Always enabled for WebPACK license):0```
		- ```CreateProgramGroupShortcuts=0```
		- ```CreateShortcutsForAllUsers=0```
		- ```CreateDesktopShortcuts=0```
		- ```CreateFileAssociation=0```
	- Save with ```:wq```

- Xilinx Unified Installer (download only)
	- This should launch an X11-based Xilinx Unified Installer Setup window on your host
	- Continue with curent version if prompted that a new version exists: ```Continue```
	- Skip welcome screen: ```Next```
	- Enter User ID and Password in the ```User Authentication``` section
	- Select the ```Download Full Image (Install Separately)```
		- Use the defaults:
			- download directory: ```/opt/Xilinx/Downloads/v2019.2```
			- platform selection: ```Linux```
	- Continue: ```Next```
	- Create the download directory (in the container) when prompted: ```Yes```
	- Select Product to Install: ```Vitis```
	- Futher configure the installation:
		- Design Tools
			- Uncheck DocNav
		- Installation Options
			- Uncheck Acquire of Manage a License Key
			- Uncheck Enable Webtalk for Vivado
	- Review the download summary:
		- Download location: 
			- ```/opt/Xilinx/Downloads/2019.2```
		- Disk Space Required:
			- ```Download Size: 27.22 GB```
			- ```Disk Space Required: 27.22 GB```
		- Download Platform
			- ```Linux```
	- Download the files for offline install: ```Download```
	- Finish the download: ```OK```

- Review the generated dependencies

```bash
bash:
-rw-r--r-- 1 xilinx xilinx 1554 Dec 18 14:19 keyboard_settings.conf
-rw-r--r-- 1 xilinx xilinx 1940 Dec 18 14:19 xlnx_unified_vitis.config
-rw-rw-r-- 1 xilinx xilinx  227 Dec 18 14:19 XTerm
```

- Copy the generated dependencies to the dependency folder

```bash
bash:
$ cp _generated/configs/* configs/
$ cp _generated/depends/* depends/
```

## Build a v2019.2 Vitis Image (one time)

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
Base docker image [found] (ubuntu:18.04.1)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
Xilinx MALI Binaries: [Good] depends/mali-400-userspace.tar
Xilinx Vivado Web Installer: [Good] depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin
Xilinx Vivado Offline Installer: [Good] depends/Xilinx_Unified_2019.2_1024_1831_Lin64.bin.tar.gz
XTerm Configuration File: [Good] configs/XTerm
-----------------------------------

...

-----------------------------------
Image Build Complete...
STARTED :Thu Nov 14 08:52:47 EST 2019
ENDED   :Thu Nov 14 10:03:12 EST 2019
-----------------------------------
```

- Test ZCU104 DPU Examples
- https://github.com/Xilinx/Vitis-AI/blob/master/mpsoc/README.md
