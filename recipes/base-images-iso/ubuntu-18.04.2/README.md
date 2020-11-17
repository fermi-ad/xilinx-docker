[//]: # (Readme.md - Ubuntu 18.04.2 base operating system from ISO Release)

# Organization
```
-> README.md (this file)
-> build_image.sh
-> fetch_depends.sh
-> depends/
	-> .gitignore
-> include/
	-> configuration.sh
-> logs/
	-> build_image.sh-DEBUG-LOG.txt
	-> fetch_depends.sh-DEBUG-LOG.txt
```

# Ubuntu 18.04.2 Docker Image

## Build an Ubuntu 18.04.2 base docker image from ISO Release
- Note: In 2020, Ubuntu stopped hosting interim BASE tarball releases, making it difficult to use those as the basis for docker base image generation.

### Build script configuration
- For Linux Hosts, see the file:
	- __./include/configuration.sh__

### For building on a Linux Host under the BASH Shell:
- Execute the command:
```bash
bash:
$ cd xilinx-docker/recipes/iso-base-images/ubuntu-18.04.2
$ ./build_image.sh --debug
```

#### Example: Create the Ubuntu 18.04.2 OS using the included script
```bash
bash:
$ ./build_image.sh --debug
...
REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
ubuntu-iso          18.04.2             05025006be9e        Less than a second ago   243MB
```
