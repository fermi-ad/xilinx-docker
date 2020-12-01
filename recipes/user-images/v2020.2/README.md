[//]: # (Readme.md - Base Ubuntu User Images for v2020.2 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2020.2](./README.user-install.md)
- [Install Vivado 2020.2](./README.vivado-install.md)
- [Install Vitis 2020.2](./README.vitis-install.md)

## Additional Documentation

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization

- Two user image recipes are provided
	- 18.04.2 for Petalinux, Vivado & Vitis
	- 20.04.1 for Vivado & Vitis

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

## Generate a base Ubuntu 18.04.2 image (one time)

```bash
$ pushd ../../base-images/ubuntu-18.04.2/
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
	STARTED :Fri 20 Nov 2020 12:22:11 PM EST
	ENDED   :Fri 20 Nov 2020 12:29:00 PM EST
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r-- 1 xilinx xilinx 1554 Nov 20 16:31 _generated/configs/keyboard_settings.conf
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.2 user image 
- This contains all the dependencies for the v2020.2 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
	...
	-----------------------------------
	REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
	xilinx-ubuntu-18.04.2-user   v2020.2             9d1802a9b720        1 second ago        2.26GB
	-----------------------------------
	Image Build Complete...
	STARTED :Tue 01 Dec 2020 04:37:30 PM EST
	ENDED   :Tue 01 Dec 2020 05:07:11 PM EST
	-----------------------------------
```

## Generate a base Ubuntu 20.04.1 image (one time)

```bash
$ pushd ../../base-images/ubuntu-20.04.1
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
	STARTED :Fri 20 Nov 2020 12:22:11 PM EST
	ENDED   :Fri 20 Nov 2020 12:29:00 PM EST
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r-- 1 xilinx xilinx 1554 Nov 20 16:31 _generated/configs/keyboard_settings.conf
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 20.04.1 user image 
- This contains all the dependencies for the v2020.1 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
	...

```