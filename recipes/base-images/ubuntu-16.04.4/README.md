[//]: # (Readme.md - Ubuntu 16.04.4 base operating system)

# Organization
```
-> README.md (this file)
-> build_image.sh
-> depends/
	-> .gitignore
-> include/
	-> configuration.sh
-> logs/
	-> build_image.sh-DEBUG-LOG.txt
```

# Ubuntu 16.04.4 Docker Image

## Build an Ubuntu 16.04.4 base docker image

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__

### For building on a Linux Host under the BASH Shell:
- Execute the command:
```bash
bash:
$ cd xilinx-docker/recipes/base-images/ubuntu-16.04.4
$ ./build_image.sh
```

#### Example: Create the Ubuntu 16.04.4 OS using the included script
```bash
bash:
$ ./build_image.sh
Base Release Image [Good] ubuntu-base-16.04.4-base-amd64.tar.gz
sha256:fc6c834c4aefbe1f8ea515d2a1898a6ef6ce55d8517597d0beab1f2840eab41b
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.4              3bd5992802b9        Less than a second ago   112MB
```

# Additional information

## Ubuntu base release image information
- Where does the base Ubuntu image come from?...
	- Note: This is a rootfs image, not an installation ISO

### Official Ubuntu release archives:
- http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/

### Download the Base filesystem from Ubuntu archives:
```bash
bash:
$ wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04.4-base-amd64.tar.gz
```
