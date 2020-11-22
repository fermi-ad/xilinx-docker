[//]: # (Readme.md - Ubuntu 18.04.1 base operating system)

# Organization
```
-> README.md (this file)
-> build_image.sh
-> fetch_depends.sh
-> depends/
	-> .gitignore
-> include/
	-> configuration.sh
```

# Ubuntu 18.04.1 Docker Image

## Example Workflow Using Ubuntu ISO install image

1. Fetch the Ubuntu ISO install image

```bash
bash:
$ ./fetch_depends.sh --iso --replace-existing
```

2. Build the Ubuntu Base Docker image using the ISO installer

```bash
bash:
$ sudo ./build_image.sh --iso
```

## Example Workflow using Ubuntu base tarball image

1. Fetch the Ubuntu base tarball image

```bash
bash:
$ ./fetch_depends.sh --base --replace-existing
```

2. Build the Ubuntu Base Docker image using the BASE ROOTFS tarball

```bash
bash:
$ sudo ./build_image.sh --base
```

## List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
ubuntu                       18.04.2             0a83f1240096        16 hours ago        88.3MB
ubuntu-iso                   18.04.2             6165bfac6800        16 hours ago        243MB
```





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