[//]: # (Readme.md - Base Ubuntu User Images for v2021.1 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2021.1](./README.user-install.md)
- [Install Vivado 2021.1](./README.vivado-install.md)
- [Install Vitis 2021.1](./README.vitis-install.md)

## Additional Documentation

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization

- Two user image recipes are provided
	- 18.04.5 for Petalinux, Vivado & Vitis
	- 20.04.1 for Petalinux, Vivado & Vitis

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
	STARTED :Wed 23 Jun 2021 10:18:08 AM EDT
	ENDED   :Wed 23 Jun 2021 10:23:43 AM EDT
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r-- 1 xilinx xilinx 1554 Jun 23 10:23 _generated/configs/keyboard_settings.conf
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.5 user image 
- This contains all the dependencies for the v2021.1 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
	...
	-----------------------------------
	REPOSITORY                   TAG       IMAGE ID       CREATED        SIZE
	xilinx-ubuntu-18.04.5-user   v2021.1   67a6dcb52415   1 second ago   2.45GB
	-----------------------------------
	Image Build Complete...
	STARTED :Wed 23 Jun 2021 02:13:47 PM EDT
	ENDED   :Wed 23 Jun 2021 02:39:44 PM EDT
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
	STARTED :Wed 23 Jun 2021 10:18:08 AM EDT
	ENDED   :Wed 23 Jun 2021 10:23:43 AM EDT
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r-- 1 xilinx xilinx 1554 Jun 23 10:23 _generated/configs/keyboard_settings.conf
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
	-----------------------------------
	REPOSITORY                   TAG       IMAGE ID       CREATED        SIZE
	xilinx-ubuntu-20.04.1-user   v2021.1   37f2b937e675   1 second ago   2.09GB
	-----------------------------------
	Image Build Complete...
	STARTED :Wed 23 Jun 2021 01:45:31 PM EDT
	ENDED   :Wed 23 Jun 2021 02:13:13 PM EDT
	-----------------------------------
```