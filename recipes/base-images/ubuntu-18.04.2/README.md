[//]: # (Readme.md - Ubuntu 18.04.2 base operating system)

# Organization
```
-> README.md (this file)
-> build_image.sh
-> build_image.ps1
-> depends/
	-> .gitignore
-> include/
	-> configuration.sh
	-> configuration.ps1
-> logs/
	-> build_image.sh-DEBUG-LOG.txt
	-> build_image.ps1-DEBUG-LOG.txt
```

# Ubuntu 18.04.2 Docker Image

## Build an Ubuntu 18.04.2 base docker image

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__
- For Windows 10 Hosts, see the file:
	- __./include/configuration.ps1__

### For building on a Linux Host under the BASH Shell:
- Execute the command:
```bash
bash:
$ cd xilinx-docker/recipes/base-images/ubuntu-18.04.2
$ ./build_image.sh
```

### For building on a Windows 10 Host under Powershell:
- Execute the command:
```powershell
powershell:
PS > C:\> cd xilinx-docker\recipes\base-images\ubuntu-18.04.2
PS > C:\xilinx-docker\recipes\base-images\ubuntu-18.04.2> .\buld_image.ps1
```

#### Example: Create the Ubuntu 18.04.2 OS using the included script
```bash
bash:
$ ./build_image.sh
Base Release Image [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
sha256:fc6c834c4aefbe1f8ea515d2a1898a6ef6ce55d8517597d0beab1f2840eab41b
REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
ubuntu              18.04.2             a9e9c139dbd4        Less than a second ago   112MB
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
$ wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/ubuntu-base-18.04.2-base-amd64.tar.gz
```
