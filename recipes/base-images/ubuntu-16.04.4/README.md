[//]: # (Readme.md - Ubuntu 16.04.4 base operating system)

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

# Ubuntu 16.04.4 Docker Image

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
	ubuntu-iso          16.04.4             54dac7b9ec62        Less than a second ago   203MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 10:21:21 PM EST
	ENDED   :Tue 24 Nov 2020 10:21:29 PM EST
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
	ubuntu              16.04.4             596d8e119ea0        Less than a second ago   112MB
	-----------------------------------
	Task Complete...
	STARTED :Tue 24 Nov 2020 10:23:25 PM EST
	ENDED   :Tue 24 Nov 2020 10:23:27 PM EST
	----------------------------------
```
