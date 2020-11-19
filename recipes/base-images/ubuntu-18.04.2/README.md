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