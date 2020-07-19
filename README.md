# xilinx-docker

Do you need traceable, repeatable build environments for your Xilinx Development Tools?  

This repository provides a collection of recipes and tools that enable Xilinx FPGA-based embedded development workflows in docker-ce containers.  Use the container recipes to build docker containers from scratch (not using existing base containers) that run Xilinx FPGA Development Tools.

## Host OS Setup

This repository requires installation and configuration of Docker-CE (and other support tools such as python, xterm, ...) on your host machine.

### Ubuntu Host Support

The recipes, tools and documentation in this repository have been primarily developed using an Ubuntu-based Host OS.
- [Ubuntu 18.04](./documentation/host-os-setup/ubuntu-18.04/README.md)

### Windows 10 Host Support

While Linux is the preferred Host OS environment for leveraging the content in this repository, Docker-CE can be configured to run on Windows 10.  There are some limitations that can impact usability in a Windows environment, including lack of native EXT-based filesystem support which poses challenges using Petalinux and Yocto tools in Docker containers on a Windows Host. 

While the content in this repository has been developed primarily targeting an Ubuntu-based Host, some of recipes, tools and documentation have been reworked to provide example workflows that can be used in a Windows 10 environment.
- [Windows 10](./documentation/host-os-setup/windows-10/README.md) 

Windows 10 adaptation of recipes, tools and documentation can be found in the [./recipes-windows/](./recipes-windows/) folder.

## Docker Image Recipe Overview

### Ubuntu Images

These are the Base Ubuntu OS Images used for tool installations.

| Ubuntu Release | Base Image   |
| -------------- | ----------   |
| 18.04.2        | [88.3MB][4b] |
| 18.04.1        | [83.5MB][3b] |

### Xilinx User Images (Manual Tool Installation)

These user images include a tool-compatible Ubuntu OS installation and all (known) base Xilinx tool dependencies for that release.  Xilinx tools are installed and configured manually by each user to create the final user image.

| Xilinx Release | User Image     | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.1        | [2.01GB][4u]   | [10.7GB][4mp] | [53.2GB][4mv] | [72.2GB][4mvi] | N/A             |
| v2019.2        | [2.02GB][3u]   | [18.4GB][3mp] | [40.9GB][3mv] | [55.4GB][3mvi] | N/A             |
| v2019.1        | [2.02GB][2u]   | [16.5GB][2mp] | [35.2GB][2mv] | N/A            | [9.99GB][2msdk] |


### Xilinx User Images (Automated/Scripted Tool Installation)

These user images include a tool-compatible Ubuntu OS installation with tool specific dependencies and the Xilinx tool pre-installed.  Xilinx tool installation is automated to support offline/archival and automation of development environment creation.  These images are slightly larger (by default) than the manually created counterparts due to the storage used for intermediate build staging during creation of these images.  These recipes are provided as examples and can further be optimized for size before deployment in your environment if necessary.

| Xilinx Release | Ubuntu Release | Petalinux     | Vivado        | Vitis          | SDK             |
| -------------- | -------------- | ---------     | ------------  | ------------   | --------------- |
| v2020.1        | [18.04.2][4u]  | [10.7GB][4ap] | [52.3GB][4av] | [71.3GB][4avi] | N/A             |
| v2019.2        | [18.04.2][3u]  | [18.4GB][3ap] | [40.9GB][3av] | [55.2GB][3avi] | N/A             |
| v2019.1        | [18.04.1][2u]  | [18.4GB][2ap] | [40.9GB][2av] | N/A            | [TB.DGB][3asdk] |

#### Automated Image Build Times

These build times are approximate, rounded to the nearest minute and reflect one particular build machine configuration.

| Xilinx Release | User Image     | Petalinux     | Vivado        | Vitis        | SDK       |
| -------------- | -------------- | ------------- | ------------- | ------------ | --------- |
| v2020.1        | 6 min          | 5 min         | 54 min        | 1 hr, 21 min | N/A       |
| v2019.2        | 6 min          | 9 min         | 39 min        | 45 min       | N/A       |
| v2019.1        | X min          | X min         | XX min        | N/A          | XX min    |



[4b]: ./recipes/base-images/ubuntu-18.04.2/README.md
[3b]: ./recipes/base-images/ubuntu-18.04.1/README.md

[4u]: ./recipes/user-images/v2020.1/README.md
[3u]: ./recipes/user-images/v2019.2/README.md
[2u]: ./recipes/user-images/v2019.1/README.md

[4mp]: ./recipes/user-images/v2020.1/README.petalinux-install.md
[3mp]: ./recipes/user-images/v2019.2/README.petalinux-install.md
[2mp]: ./recipes/user-images/v2019.1/README.petalinux-install.md

[4mv]: ./recipes/user-images/v2020.1/README.vivado-install.md
[3mv]: ./recipes/user-images/v2019.2/README.vivado-install.md

[4mvi]: ./recipes/user-images/v2020.1/README.vitis-install.md
[3mvi]: ./recipes/user-images/v2019.2/README.vitis-install.md

[3msdk]: ./recipes/user-images/v2019.1/README.sdk-install.md

[4ap]: ./recipes/automated-images/petalinux/v2020.1/README.md
[3ap]: ./recipes/automated-images/petalinux/v2019.2/README.md

[4av]: ./recipes/automated-images/vivado/v2020.1/README.md
[3av]: ./recipes/automated-images/vivado/v2019.2/README.md

[4avi]: ./recipes/automated-images/vitis/v2020.1/README.md
[3avi]: ./recipes/automated-images/vitis/v2019.2/README.md

[3asdk]: ./recipes/automated-images/sdk/v2019.1/README.md

## Workflow overviews

The recipes in this repository support two separate development environment creation workflows.

1. Manual Xilinx Tool installation

The goal of this workflow is to quickly setup and start using Xilinx tools in Docker containers.

This workflow consists of:
- Scripted creation of the base OS with tool dependencies pre-installed.
- Manual installation of Xilinx Tools.
- Committing changes to local repository to create a new images including the Xilinx tools pre-installed.

2. Automated Xilinx Tool installation

The goal of this workflow is to automate creation of docker containers with Xilinx tools pre-installed.  This workflow requires the pre-generation of installation dependencies (configuration files) used by the automated image build.  The pre-generation of dependencies is a semi-automated, scripted process but does require user interaction during the process.

This workflow consists of:
- Dependency Generation
	- Scripted generation of OS configuration dependencies used in the automated scripting of Xilinx tool installation.
	- This requires user input and generates OS and Xilinx installer configuration files.
- Automated Image Build
	- Scripted createion of the nase OS with tool dependencies pre-installed.
	- Scripted installation of Xilinx Tools.
	- Results in a Docker image stored in the local repository.
	
### Manual Xilinx Tool installation quickstart

For the latest v2020.1 Xilinx Tools:
- [Build a base Ubuntu Docker Image](./recipes/base-images/ubuntu-18.04.2/README.md)
- [Build an Ubuntu User Image](./recipes/user-images/v2020.1/README.md)
- Manually install the Xilinx Tools
	- [Manual Vivado Installation](./recipes/user-images/v2020.1/README.vivado-install.md)
	- [Manual Vitis Installation](./recipes/user-images/v2020.1/README.vitis-install.md)
	- [Manual Petalinux Installation](./recipes/user-images/v2020.1/README.petalinux-install.md)

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
