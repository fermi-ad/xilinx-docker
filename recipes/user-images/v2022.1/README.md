[//]: # (Readme.md - Base Ubuntu User Images for v2022.1 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2022.1](./README.user-install.md)
- [Install Vivado 2022.1](./README.vivado-install.md)
- [Install Vitis 2022.1](./README.vitis-install.md)

## Additional Documentation

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization

- Two user image recipes are provided
	- 18.04.5 for Petalinux, Vivado & Vitis (Default Option - Vitis AI/DPU Workflow supported)
	- NEEDS TESTED: 20.04.x for Petalinux, Vivado & Vitis
		- In 2022.1, this worked fine for normal tool flows and other TRDS but did not work with Vitis-AI designs and DPU workflows.
		- There was an unresolved Segfault with Ubuntu 20.04.x during impementation when running in a docker container
		- Previous recommendation was to use 18.04.5 for compatibility
		- THIS STILL NEEDS TO BE VERIFIED FOR 2022.1

```
-> .dockerignore
-> build_image.sh
-> generate_configs.sh
-> Dockerfile.base
-> Dockerfile.iso
-> Dockerfile.generate_configs
-> Dockerfile.iso.generate_configs
-> configs/
	-> .minirc.dfl
	-> keyboard_settings.conf
	-> XTerm
-> include/
	-> configuration.sh
```

# Quickstart

## Generate a base Ubuntu 18.04.5 image (one time)

```bash
$ pushd ../../base-images/ubuntu-18.04.5/
$ sudo ./build_image.sh --iso
$ popd
```

## Generate Configuration Files (one time)

```bash
$ ./generate_configs.sh --iso
```

- Follow the build process in the terminal (manual interaction required)
- Keyboard configuration
	- Select a keyboard model: ```Generic 105-key (Intl) PC``` is the default
	- Select a country of origin for the keyboard: ```English (US)``` is the default
	- Select a keyboard layout: ```English (US)``` is the default
	- Select an AltGr function: ```The default for the keyboard layout``` is the default
	- Select a compose key: ```No compose key``` is the default

- Review the generated configurations

```bash
bash:
	...
	-----------------------------------
	Configuration Generation Complete
	-----------------------------------
	STARTED :Tue 02 Nov 2021 09:33:45 AM EDT
	ENDED   :Tue 02 Nov 2021 09:37:55 AM EDT
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r--. 1 rjmoss rjmoss 1554 Feb 12 11:06 _generated/configs/keyboard_settings.conf
	-----------------------------------
	Copying Configurations to the configs Folder
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.5 user image 
- This contains all the dependencies for the v2021.2 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
	...
	-----------------------------------
	REPOSITORY                   TAG       IMAGE ID       CREATED                  SIZE
	xilinx-ubuntu-18.04.5-user   v2022.1   3948232ade92   Less than a second ago   2.69GB
	-----------------------------------
	Image Build Complete...
	STARTED :Sun Feb 12 11:07:17 EST 2023
	ENDED   :Sun Feb 12 11:19:22 EST 2023
	-----------------------------------
```
