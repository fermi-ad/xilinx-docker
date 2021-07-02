[//]: # (Readme.md - Ubuntu 18.04.5 base operating system)

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
	REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
	ubuntu-iso   18.04.5   6e327afb5454   4 seconds ago   670MB
	-----------------------------------
	Task Complete...
	STARTED :Wed 23 Jun 2021 10:10:22 AM EDT
	ENDED   :Wed 23 Jun 2021 10:10:53 AM EDT
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
REPOSITORY   TAG       IMAGE ID       CREATED                  SIZE
ubuntu       18.04.5   831396059df6   Less than a second ago   63.2MB
-----------------------------------
Task Complete...
STARTED :Wed 23 Jun 2021 10:11:16 AM EDT
ENDED   :Wed 23 Jun 2021 10:11:18 AM EDT
-----------------------------------
```
