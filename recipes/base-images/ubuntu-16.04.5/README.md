[//]: # (Readme.md - Ubuntu 16.04.5 base operating system)

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

# Ubuntu 16.04.5 Docker Image

## Build an Ubuntu 16.04.5 base docker image

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__

### For building on a Linux Host under the BASH Shell:
- Execute the commands:
```bash
bash:
$ cd xilinx-docker/recipes/base-images/ubuntu-16.04.5
$ ./build_image.sh
```

#### Example: Create the Ubuntu 16.04.5 OS using the included script
```bash
bash:
$ ./build_image.sh
Base Relese Image Download [Good] ubuntu-base-16.04.5-base-amd64.tar.gz
sha256:1efa3cdb03d6333d4e49eeaffaa509992cbc37759ab63fbb4584597fc9231598
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.5              aaf26e234104        Less than a second ago   115MB
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
$ wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04.5-base-amd64.tar.gz
```
