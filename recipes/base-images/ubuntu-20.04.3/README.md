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

# Ubuntu 20.04.3 Docker Base Image Quickstart

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
Importing rootfs into docker...
sha256:f838701c88d9fd80842d1925ed1a0069801a87af9a651be95ac51e89bf961afd
REPOSITORY   TAG       IMAGE ID       CREATED                  SIZE
ubuntu-iso   20.04.3   f838701c88d9   Less than a second ago   909MB
Unmounting ISO image...
Removing temporary directories...
-----------------------------------
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
ubuntu-iso   20.04.3   f838701c88d9   1 second ago     909MB
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
ubuntu       20.04.3   5b3221ebb639   Less than a second ago   72.8MB
```
