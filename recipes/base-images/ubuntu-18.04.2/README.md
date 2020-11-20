[//]: # (Readme.md - Ubuntu 18.04.2 base operating system)

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

# Ubuntu 18.04.2 Docker Base Image Quickstart

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
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	ubuntu-iso          18.04.2             e349972b7588        1 second ago        243MB
	-----------------------------------
	Task Complete...
	STARTED :Fri 20 Nov 2020 12:09:34 PM EST
	ENDED   :Fri 20 Nov 2020 12:09:43 PM EST
	-----------------------------------
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
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	ubuntu              18.04.2             92555c3294c4        1 second ago        88.3MB
	-----------------------------------
	Task Complete...
	STARTED :Fri 20 Nov 2020 12:08:33 PM EST
	ENDED   :Fri 20 Nov 2020 12:08:36 PM EST
	-----------------------------------
```
