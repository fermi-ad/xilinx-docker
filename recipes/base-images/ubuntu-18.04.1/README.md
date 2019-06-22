[//]: # (Readme.md - Ubuntu 18.04.1 base operating system)

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

# Ubuntu 18.04.1 Docker Image

## Build an Ubuntu 18.04.1 base docker image

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__
- For Windows 10 Hosts, see the file:
	- __./include/configuration.ps1__

### For building on a Linux Host under the BASH Shell:
- Execute the command:
```bash
bash:
$ cd xilinx-docker/recipes/base-images/ubuntu-18.04.1
$ ./build_image.sh
```

### For building on a Windows 10 Host under Powershell:
- Execute the command:
```powershell
powershell:
PS > C:\> cd xilinx-docker\recipes\base-images\ubuntu-18.04.1
PS > C:\xilinx-docker\recipes\base-images\ubuntu-18.04.1> .\buld_image.ps1
```

#### Example: Create the Ubuntu 18.04.1 OS using the included script
```bash
bash:
$ ./build_image.sh
Base Relese Image Download [Good] ubuntu-base-18.04.1-base-amd64.tar.gz
sha256:4112b3ccf8569cf0e67fe5b99c011ab93a27dd42137ea26f88f070b52f8e15a8
REPOSITORY               TAG                 IMAGE ID            CREATED                  SIZE
ubuntu                   18.04.1             4112b3ccf856        Less than a second ago   83.5MB
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