[//]: # (Readme.md - Ubuntu 20.04.1 base operating system)

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

# Ubuntu 20.04.1 Docker Base Image Quickstart

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
	ubuntu-iso          20.04.1             803d92d833cd        1 second ago        267MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 01 Dec 2020 04:11:19 PM EST
	ENDED   :Tue 01 Dec 2020 04:11:28 PM EST
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
	REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
	ubuntu              20.04.1             16d905ba1cbe        Less than a second ago   72.9MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 01 Dec 2020 10:49:25 AM EST
	ENDED   :Tue 01 Dec 2020 10:49:28 AM EST
	-----------------------------------
```
