[//]: # (Readme.md - Base Ubuntu User Image for v2020.1 Xilinx Tools)

# References

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2020.1](./README.user-install.md)
- [Install Vivado 2020.1](./README.vivado-install.md)
- [Install Vitis 2020.1](./README.vitis-install.md)

## Additional Documentation

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
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1554 Nov 17 16:31 _generated/configs/keyboard_settings.conf
-----------------------------------
```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 18.04.2 user image 
- This contains all the dependencies for the v2020.1 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh --iso
```

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.2-user   v2020.1             e95d2bfeeae2        15 hours ago        2.26GB
ubuntu-iso                   18.04.2             6165bfac6800        16 hours ago        243MB
```
