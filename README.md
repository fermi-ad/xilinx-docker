# xilinx-docker

Do you need traceable, repeatable build environments for your Xilinx Development Tools?  

This repository provides a collection of recipes and tools that enable Xilinx FPGA-based embedded development workflows in docker-ce containers.  Use the container recipes to build docker containers from scratch (not using existing base containers) that run Xilinx FPGA Development Tools.

## About the layered image approach

Docker images are layered (generically) as follows:

- ```[Base OS Image]```
	- ```--> [User OS Image]```
		- ```--> [Xilinx Tool Image]```


The ```[Base OS Image]``` contains a basic root filesystem that supports package management and command line interaction.
The ```[User OS Image]``` contains all dependencies and configurations to install and use of Xilinx tools in the container.
The ```[Xilinx Tool Image]``` contains the complete installation of the Xilinx development tool.

## Host OS Setup

This repository requires installation and configuration of Docker-CE (and other support tools such as python, xterm, ...) on your host machine.

### Ubuntu Host Support

The recipes, tools and documentation in this repository have been primarily developed using an Ubuntu-based Host OS.
- [Ubuntu 20.04](./documentation/host-os-setup/ubuntu-20.04/README.md)
- [Ubuntu 18.04](./documentation/host-os-setup/ubuntu-18.04/README.md)

### Windows 10 Host Support

While Linux is the preferred Host OS environment for leveraging the content in this repository, Docker-CE can be configured to run on Windows 10.  There are some limitations that can impact usability in a Windows environment, including lack of native EXT-based filesystem support which poses challenges using Petalinux and Yocto tools in Docker containers on a Windows Host. 

While the content in this repository has been developed primarily targeting an Ubuntu-based Host, some of recipes, tools and documentation have been reworked to provide example workflows that can be used in a Windows 10 environment.
- [Windows 10](./documentation/host-os-setup/windows-10/README.md) 

Windows 10 adaptation of recipes, tools and documentation can be found in the [./recipes-windows/](./recipes-windows/) folder.

## Docker Image Recipe Overview

### About Ubuntu Image Point Releases and Base Image Tarball Availability

Ubuntu provides Base Image tarballs for each point release during active standard support for an LTS release. See: [ubuntu-base/releases](http://cdimage.ubuntu.com/ubuntu-base/releases/).  

Interim/older point releases for an LTS version are periodically removed from the Ubuntu image archive so there is no guaranteed availability of point release base images.  This makes the base image tarball a poor choice for creating and maintaining base docker images for long-term development environment maintenance, unless you keep your own archive of these base release images.

Recipes have been added to this repository to offer the option of creating and using the release ISO installer for point releases as the base for docker image creation.  See: [old-releases.ubuntu.com/releases](http://old-releases.ubuntu.com/releases/)


### Ubuntu Images

These are the Base Ubuntu OS Images used for tool installations.
There are two sizes listed based on if the image is generated from a base tarball release or an iso installer image.

| Ubuntu Release | Base ISO Image | Base Image   | 
| -------------- | -------------- | ------------ |
| 20.04.1        | [267MB][5b]    | [72.9MB][5b] |
| 18.04.2        | [243MB][4b]    | [88.3MB][4b] | 
| 18.04.1        | [238MB][3b]    | [83.5MB][3b] |
| 16.04.4		 | [203MB][1b]    | [112MB][1b]  |
| 16.04.3		 | [210MB][0b]    | [120MB][0b]  |

### Xilinx User Images (Manual Tool Installation)

These user images include a tool-compatible Ubuntu OS installation and all (known) base Xilinx tool dependencies for that release.  Xilinx tools are installed and configured manually by each user to create the final user image.

Image sizes in this table reflect images created from the Base ISO Image.

User Image Sizes:

| Xilinx Release | Ubuntu Release | User Image     | 
| -------------- | -------------- | ----------     |
| v2020.2        | [20.04.1][5u2] | [1.71GB][5u]  |
| v2020.2        | [18.04.2][5u1] | [2.26GB][5u]  |
| v2020.1        | [18.04.2][4u]  | [2.26GB][4u]   |
| v2019.2        | [18.04.2][3u]  | [2.26GB][3u]   |
| v2019.1        | [18.04.1][2u]  | [2.26GB][2u]   |

New ISO Based Images:

| Xilinx Release | User Image     | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.2		 | [1.69GB][5u]   | N/A           | [69.9GB][5mv] | [79.9GB][5mvi] | N/A             |
| v2020.2        | [2.26GB][5u]   | [12.3GB][4mp] | N/A           | N/A            | N/A             |

Old BASE Rootfs Based Images:

| Xilinx Release | User Image     | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.1        | [2.26GB][4u]   | [10.9GB][4mp] | [52.2GB][4mv] | [71.5GB][4mvi] | N/A             |
| v2019.2        | [2.26GB][3u]   | [18.7GB][3mp] | [41.1GB][3mv] | [55.5GB][3mvi] | N/A             |
| v2019.1        | [2.02GB][2u]   | [16.5GB][2mp] | [35.2GB][2mv] | N/A            | [9.99GB][2msdk] |
| v2018.3        | [1.61GB][1u]   | [15.9GB][1mp] | [58.3GB][1mv] | N/A            | [12.2GB][1msdk] |
| v2018.2        | [1.62GB][0u]   | [16.2GB][0mp] | [54.5GB][0mv] | N/A            | [12.0GB][0msdk] |

### Xilinx User Images (Automated/Scripted Tool Installation)

These user images include a tool-compatible Ubuntu OS installation with tool specific dependencies and the Xilinx tool pre-installed.  Xilinx tool installation is automated to support offline/archival and automation of development environment creation.  These images are slightly larger (by default) than the manually created counterparts due to the storage used for intermediate build staging during creation of these images.  These recipes are provided as examples and can further be optimized for size before deployment in your environment if necessary.

New ISO Based Images:

| Xilinx Release | Ubuntu Release | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.2        | [20.04.1][5u]  | N/A           | [69.9GB][5mv] | [TBD GB][5mvi] | N/A             |
| v2020.2        | [18.04.2][5u]  | [12.3GB][5mp] | N/A           | N/A            | N/A             |
| v2020.1        | [18.04.2][4u]  | [10.9GB][4mp] | [52.2GB][4mv] | [71.5GB][4mvi] | N/A             |
| v2019.2        | [18.04.2][3u]  | [18.7GB][3mp] | [41.1GB][3mv] | [55.5GB][3mvi] | N/A             |

Base RootFS Release Based Images:

| Xilinx Release | Ubuntu Release | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.1        | [18.04.2][4u]  | [10.9GB][4ap] | [52.3GB][4av] | [71.3GB][4avi] | N/A             |
| v2019.2        | [18.04.2][3u]  | [18.4GB][3ap] | [40.9GB][3av] | [55.2GB][3avi] | N/A             |
| v2019.1        | [18.04.1][2u]  | [16.5GB][2ap] | [35.2GB][2av] | N/A            | [9.96GB][2asdk] |
| v2018.3        | [16.04.4][1u]  | [15.9GB][1ap] | [43.4GB][1av] | N/A            | [10.6GB][1asdk] |
| v2018.2        | [16.04.3][0u]  | [16.2GB][0ap] | [40.3GB][0av] | N/A            | [10.4GB][0asdk] |

#### Automated Image Build Times

These build times are approximate, rounded to the nearest minute and reflect one particular build machine configuration.


| Xilinx Release | User Image     | Petalinux     | Vivado        | Vitis        | SDK       |
| -------------- | -------------- | ------------- | ------------- | ------------ | --------- |
| v2020.2        | 9 min          | 7 min         | 2 hr 13 min   | 2 hr, 45 min | N/A       |
| v2020.1        | 6 min          | 5 min         | 54 min        | 2 hr, 25 min | N/A       |
| v2019.2        | 6 min          | 9 min         | 39 min        | 45 min       | N/A       |
| v2019.1        | 6 min          | 8 min         | 27 min        | N/A          | 4 min     |
| v2018.3        | 5 min          | 11 min        | 26 min        | N/A          | 4 min     |
| v2018.2        | 5 min          | 13 min        | 25 min        | N/A          | 4 min     |


[5b]: ./recipes/base-images/ubuntu-20.04.1/README.md
[4b]: ./recipes/base-images/ubuntu-18.04.2/README.md
[3b]: ./recipes/base-images/ubuntu-18.04.1/README.md
[1b]: ./recipes/base-images/ubuntu-16.04.4/README.md
[0b]: ./recipes/base-images/ubuntu-16.04.3/README.md

[5u]: ./recipes/user-images/v2020.2/README.md
[4u]: ./recipes/user-images/v2020.1/README.md
[3u]: ./recipes/user-images/v2019.2/README.md
[2u]: ./recipes/user-images/v2019.1/README.md
[1u]: ./recipes/user-images/v2018.3/README.md
[0u]: ./recipes/user-images/v2018.2/README.md

[5mp]: ./recipes/user-images/v2020.2/README.petalinux-install.md
[4mp]: ./recipes/user-images/v2020.1/README.petalinux-install.md
[3mp]: ./recipes/user-images/v2019.2/README.petalinux-install.md
[2mp]: ./recipes/user-images/v2019.1/README.petalinux-install.md
[1mp]: ./recipes/user-images/v2018.3/README.petalinux-install.md
[0mp]: ./recipes/user-images/v2018.2/README.petalinux-install.md

[4mv]: ./recipes/user-images/v2020.1/README.vivado-install.md
[3mv]: ./recipes/user-images/v2019.2/README.vivado-install.md
[2mv]: ./recipes/user-images/v2019.1/README.vivado-install.md
[1mv]: ./recipes/user-images/v2018.3/README.vivado-install.md
[0mv]: ./recipes/user-images/v2018.2/README.vivado-install.md

[4mvi]: ./recipes/user-images/v2020.1/README.vitis-install.md
[3mvi]: ./recipes/user-images/v2019.2/README.vitis-install.md

[2msdk]: ./recipes/user-images/v2019.1/README.sdk-install.md
[1msdk]: ./recipes/user-images/v2018.3/README.sdk-install.md
[0msdk]: ./recipes/user-images/v2018.2/README.sdk-install.md

[4ap]: ./recipes/automated-images/petalinux/v2020.1/README.md
[3ap]: ./recipes/automated-images/petalinux/v2019.2/README.md
[2ap]: ./recipes/automated-images/petalinux/v2019.1/README.md
[1ap]: ./recipes/automated-images/petalinux/v2018.3/README.md
[0ap]: ./recipes/automated-images/petalinux/v2018.2/README.md

[4av]: ./recipes/automated-images/vivado/v2020.1/README.md
[3av]: ./recipes/automated-images/vivado/v2019.2/README.md
[2av]: ./recipes/automated-images/vivado/v2019.1/README.md
[1av]: ./recipes/automated-images/vivado/v2018.3/README.md
[0av]: ./recipes/automated-images/vivado/v2018.2/README.md

[4avi]: ./recipes/automated-images/vitis/v2020.1/README.md
[3avi]: ./recipes/automated-images/vitis/v2019.2/README.md

[2asdk]: ./recipes/automated-images/sdk/v2019.1/README.md
[1asdk]: ./recipes/automated-images/sdk/v2018.3/README.md
[0asdk]: ./recipes/automated-images/sdk/v2018.2/README.md

# Workflow overviews

The recipes in this repository support two separate development environment creation workflows.

## Manual Xilinx Tool installation

The goal of this workflow is to quickly setup and start using Xilinx tools in Docker containers.

This workflow consists of:
- Scripted creation of the base OS with tool dependencies pre-installed.
- Manual installation of Xilinx Tools.
- Committing changes to local repository to create a new images including the Xilinx tools pre-installed.

### Manual Xilinx Tool installation quickstart

For the latest v2020.1 Xilinx Tools:
- [Build a base Ubuntu Docker Image](./recipes/base-images/ubuntu-18.04.2/README.md)
- [Build an Ubuntu User Image](./recipes/user-images/v2020.1/README.md)
- Manually install the Xilinx Tools
	- [Manual Vivado Installation](./recipes/user-images/v2020.1/README.vivado-install.md)
	- [Manual Vitis Installation](./recipes/user-images/v2020.1/README.vitis-install.md)
	- [Manual Petalinux Installation](./recipes/user-images/v2020.1/README.petalinux-install.md)

## Automated Xilinx Tool installation

The goal of this workflow is to automate creation of docker containers with Xilinx tools pre-installed.  This workflow requires the pre-generation of installation dependencies (configuration files) used by the automated image build.  The pre-generation of dependencies is a semi-automated, scripted process but does require user interaction during the process.

This workflow consists of:
- Dependency Generation
	- Scripted generation of OS configuration dependencies used in the automated scripting of Xilinx tool installation.
	- This requires user input and generates OS and Xilinx installer configuration files.
- Automated Image Build
	- Scripted createion of the nase OS with tool dependencies pre-installed.
	- Scripted installation of Xilinx Tools.
	- Results in a Docker image stored in the local repository.
	
### Automated Xilinx Tool installation quickstart

For the latest v2020.1 Xilinx Tools:
- [Build a base Ubuntu Docker Image](./recipes/base-images/ubuntu-18.04.2/README.md)
- [Build an Ubuntu User Image](./recipes/user-images/v2020.1/README.md)
- Generate install configurations and dependencies
	- [Generate Vivado Install Configuration files](./recipes/automated-images/vivado/v2020.1/README.md#generate-vivado-image-install-configuration-files-one-time)
	- [Generate Vitis Installation Configuration files](./recipes/automated-images/vitis/v2020.1/README.md#generate-vitis-image-install-configuration-files-one-time)
	- [Generate Petalinux Installation Configuration files](recipes/automated-images/vivado/v2020.1/README.md#generate-petalinux-image-install-configuration-files-one-time)
- Build Docker images with Xilinx Tools pre-installed
	- [Automated Vivado Installation](./recipes/automated-images/vivado/v2020.1/README.md)
	- [Automated Vitis Installation](./recipes/automated-images/vitis/v2020.1/README.md)
	- [Automated Petalinux Installation](./recipes/automated-images/petalinux/v2020.1/README.md)
