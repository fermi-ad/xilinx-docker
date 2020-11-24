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
	...
	-----------------------------------
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	ubuntu-iso          18.04.1             b2b31f343d6a        1 second ago        238MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 03:53:53 PM EST
	ENDED   :Tue 24 Nov 2020 03:54:02 PM EST
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
	ubuntu              18.04.1             2a3d27e2eca9        Less than a second ago   83.5MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 03:53:53 PM EST
	ENDED   :Tue 24 Nov 2020 03:54:02 PM EST
	-----------------------------------
```
