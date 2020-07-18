[//]: # (Readme.md - Ubuntu 18.04.1 base operating system)

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

# Ubuntu 18.04.1 Docker Image

## Build an Ubuntu 18.04.1 base docker image

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__

### For building on a Linux Host under the BASH Shell:
- Execute the command:
```bash
bash:
$ cd xilinx-docker/recipes/base-images/ubuntu-18.04.1
$ ./build_image.sh
```

#### Example: Create the Ubuntu 18.04.1 OS using the included script
```bash
bash:
$ ./build_image.sh
Base Relese Image Download [Good] ubuntu-base-18.04.1-base-amd64.tar.gz
sha256:1f5eefc33d49b91eba954d0355917290c0e45d54f1e59ce0c918fade26662c89
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.1              1f5eefc33d49        Less than a second ago   83.5MB
```

# Additional information

## Ubuntu base release image information
- Where does the base Ubuntu image come from?...
	- Note: This is a rootfs image, not an installation ISO

### Official Ubuntu release archives:
- http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/

### Download the Base filesystem from Ubuntu archives:
```bash
bash:
$ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/ubuntu-base-18.04.1-base-amd64.tar.gz
```