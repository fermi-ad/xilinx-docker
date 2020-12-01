[//]: # (Readme.md - Ubuntu 16.04.3 base operating system)

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

# Ubuntu 16.04.3 Docker Image

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
	REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
	ubuntu-iso          16.04.3             542e1cc308f2        Less than a second ago   210MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 10:31:14 PM EST
	ENDED   :Tue 24 Nov 2020 10:31:22 PM EST
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
	ubuntu              16.04.3             4f342d0bb2a7        1 second ago        120MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 10:31:49 PM EST
	ENDED   :Tue 24 Nov 2020 10:31:51 PM EST
	-----------------------------------
```
