[//]: # (Readme.md - Base Ubuntu User Images for v2023.1 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2023.1](./README.petalinux-install.md)
- [Install Vitis/Vivado 2023.1](./README.vitis-install.md)

## Additional Documentation

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_configs.sh
-> Dockerfile.iso
-> Dockerfile.iso.generate_configs
-> configs/
	-> .minirc.dfl
	-> keyboard_settings.conf
	-> XTerm
-> include/
	-> configuration.sh
```

# Quickstart

## Generate a base Ubuntu 20.04.4 image (one time)

```bash
$ pushd ../../base-images/ubuntu-20.04.4/
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
	-rw-r--r--. 1 xilinx xilinx 1554 Feb 12 11:06 _generated/configs/keyboard_settings.conf
	-----------------------------------
	Copying Configurations to the configs Folder
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 20.04.4 user image 
- This contains all the dependencies for the v2023.1 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
	...
	-----------------------------------
	REPOSITORY                   TAG       IMAGE ID       CREATED         SIZE
	xilinx-ubuntu-20.04.4-user   v2023.1   d1b4ab412c2d   5 days ago      2.97GB
	-----------------------------------
	Image Build Complete...
	STARTED :Thu Aug 22 12:36:28 PM EDT 2024
	ENDED   :Thu Aug 22 12:47:29 PM EDT 2024
	-----------------------------------
```
