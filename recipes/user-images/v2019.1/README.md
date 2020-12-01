[//]: # (Readme.md - Base Ubuntu User Image for v2019.1 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2019.1](./README.user-install.md)
- [Install Vivado 2019.1](./README.vivado-install.md)
- [Install Vitis 2019.1](./README.vitis-install.md)

## Additional References

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)
- [Creating Docker Containers from Images](../../../documentation/creating-containers-from-docker-images/README.md)

# Organization
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
``` configuration.sh
```

# Quickstart

## Generate a base Ubuntu 18.04.1 image (one time)

```bash
$ pushd ../../base-images/ubuntu-18.04.1/
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
	STARTED :Wed 25 Nov 2020 09:48:31 AM EST
	ENDED   :Wed 25 Nov 2020 09:54:42 AM EST
	-----------------------------------
	...
	-----------------------------------
	Configurations Generated:
	-----------------------------------
	-rw-r--r-- 1 rjmoss rjmoss 1554 Nov 25 09:54 _generated/configs/keyboard_settings.conf
	-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.1 user image 
- This contains all the dependencies for the v2019.1 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
	...
	-----------------------------------
	REPOSITORY                   TAG                 IMAGE ID            CREATED                  SIZE
	xilinx-ubuntu-18.04.1-user   v2019.1             29753dff6f00        Less than a second ago   2.26GB
	-----------------------------------
	Image Build Complete...
	STARTED :Wed 25 Nov 2020 10:55:49 AM EST
	ENDED   :Wed 25 Nov 2020 11:24:58 AM EST
	-----------------------------------
```
