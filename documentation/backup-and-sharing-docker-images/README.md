[//]: # (Readme.md - Backup and Sharing of Docker Containers and Images)

# Backup and Sharing of Working Containers and Images
- Docker images and containers can be backed up to tar archive files
	- Similar to a Virtual Machine image created in VMWare or Virtualbox, you can store, share and later restore working containers from a tar archive
- A docker container is __*exported*__ to an archive file
- A docker image is __*saved*__ or __*exported*__ to an archive file
- A docker image that was __*saved*__ should be __*loaded*__ to restore the image from an archive
- A docker image or container that was __*exported*__ should be __*imported*__ to create a new image from an 
- The major differences between a __*save*__ and an __*export*__
	- A __*saved*__ image retains the complete layer history of the docker image and any configuration of that image (based on the as commit to the repository)
	- An __*exported*__ image or container retains only the state of the filesystem and therefore will start up logged in as the user root.
	- Loading an image backup with full history retains operational state of the loaded image (including what user should be logged in).
	- Importing an image or container backup does not retain operational state since the history is lost, so the __*run_image_x11_macaddr.sh*__ script provided in the tools folder of this repository sets the user to a non-root user when creating a container from an image to address one of these differences.


## Archive or Restore a Docker Container or Image
### Example: Backup the base working container's current state to a local archive file
- Create a backup image of a bare container with Vivado Tools installed and licensed using __*docker save*__
- If backing up an existing image and not a container, skip the next two steps and start with identifying the image in your repository to backup

- Stop the running container first
```bash
bash:
docker stop xilinx_petalinux_v2020.1 
xilinx_petalinux_v2020.1
```

- Commit the current state of the container to a new (temporary) docker image
```bash
bash:
$ docker commit xilinx_petalinux_v2020.1 xilinx-petalinux-backup:v2020.1
sha256:0fb2353735af7beabd419bd2e60171af68ae1130eb57f9ef190fd1fd734d370a
```

- Verify the new image saved properly to your local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-backup          v2020.1              0fb2353735af        11 seconds ago      11.8GB
xilinx-petalinux                 v2020.1              46f76f9e5d3d        19 hours ago        11.8GB
```

- Save a copy of the committed docker image to a local tar archive
```bash
bash:
$ docker save -o xlnx-petalinux-v2020.1_image_backup_saved_02deadbeef91.tar xilinx-petalinux-backup:v2020.1
```

- Verify the new archive saved to your local machine
```bash
bash:
$ ls -al xilinx-petalinux-v2020.1*
-rw------- 1 xilinx xilinx 11878394368 Jun 25 11:02 xlnx-petalinux-v2020.1_image_backup_saved_02deadbeef91.tar
```

- Remove the new (temporary) docker image
```bash
bash:
$ docker rmi xilinx-petalinux-backup:v2020.1 
Untagged: xilinx-petalinux-backup:v2020.1
Deleted: sha256:0fb2353735af7beabd419bd2e60171af68ae1130eb57f9ef190fd1fd734d370a
Deleted: sha256:08d78bc9bb309d8823441f58a8bb1f76ac6dee2e6089ea42a52058853b660b1
```

### Example: Restore a container from a backup archive image
- Use a backup archive of a docker image to re-create an environment with Petalinux Tools installed and licensed
	- __*docker load__* loads the complete history of the archived image into a new docker image
		- A load operation creates a new docker image with the same name of the image contained in the archive

### Use __*docker load*__ to bring in an archived image
- Restore a working Vivado environment from the archived image (using the one created in the above instructions)
```bash
bash:
$ docker load -i xlnx-petalinux-v2020.1_image_backup_saved_02deadbeef91.tar 
63eed60627bb: Loading layer [==================================================>]   16.9kB/16.9kB
Loaded image: xilinx-petalinux-backup:v2020.1
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-backup          v2020.1              0fb2353735af        6 minutes ago       11.8GB
xilinx-petalinux                 v2020.1              46f76f9e5d3d        19 hours ago        11.8GB
```

- See that the loaded image has a complete history, Note: intermediate image stages don't exist in the local repository.
```bash
$ docker history xilinx-petalinux-backup:v2020.1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
0fb2353735af        6 minutes ago       /bin/bash                                       1.16kB              
<missing>           19 hours ago        |13 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.14MB              
<missing>           19 hours ago        |13 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   8.68GB              
<missing>           19 hours ago        |13 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   3.17MB              
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG MINICOM_CONFIG_FILE      0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XTERM_CONFIG_FILE        0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG KEYBOARD_CONFIG_FILE     0B                  
<missing>           19 hours ago        |10 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INST…   1.32GB              
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_PETALINUX_AUTOIN…   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           19 hours ago        |7 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   163MB               
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_MALI_BINARY         0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_DOWNLOAD_LOCATION   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           19 hours ago        |8 BUILD_DEBUG=1 GIT_USER_EMAIL=Xilinx.User@…   79B                 
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG GIT_USER_EMAIL           0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG GIT_USER_NAME            0B                  
<missing>           19 hours ago        |6 BUILD_DEBUG=1 HOME_DIR=/home/xilinx INSTA…   1.16GB              
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG INSTALL_SERVER_URL       0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_PETALINUX_INSTAL…   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  USER xilinx                  0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           19 hours ago        |4 BUILD_DEBUG=1 HOME_DIR=/home/xilinx USER_…   41.6MB              
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG XLNX_INSTALL_LOCATION    0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG HOME_DIR                 0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG USER_ACCT                0B                  
<missing>           19 hours ago        |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   41.5MB              
<missing>           19 hours ago        |1 BUILD_DEBUG=1 /bin/sh -c if [ $BUILD_DEBU…   294MB               
<missing>           19 hours ago        /bin/sh -c #(nop)  ARG BUILD_DEBUG              0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B                  
<missing>           19 hours ago        /bin/sh -c #(nop)  LABEL author=Jason Moss      0B                  
<missing>           25 hours ago                                                        88.3MB              Imported from -
```

- Create a running container based on the loaded image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh  xilinx-petalinux-backup:v2020.1 xilinx_petalinux_backup_v2020.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux-backup:v2020.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_backup_v2020.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
936f8f1e66df1b740b6f7e36eac1009fa87e65c75c4177c709cdd37b7e74f4ab
```

## Archive a Docker Container filesystem or Create a new Image from a filesystem archive
### Example: Backup a running container's filesystem to an archive file
- Create a filesystem archive from a running container with Petalinux installed

- Export a copy of a running docker container to an image archive
```bash
bash:
$ docker export -o xlnx-petalinux-v2020.1_container_backup_02deadbeef91.tar xilinx_petalinux_v2020.1
```

- Verify the new filesystem archive saved to your local machine
- Note how much smaller the container backup is!
	- This is due to export capturing the filesystem state only, not the history of the image and associated layers!
```bash
bash:
$ ls -al xlnx-petalinux-v2020.1*
-rw------- 1 xilinx xilinx  9840520704 Jun 25 11:09 xlnx-petalinux-v2020.1_container_backup_02deadbeef91.tar
-rw------- 1 xilinx xilinx 11878394368 Jun 25 11:02 xlnx-petalinux-v2020.1_image_backup_saved_02deadbeef91.tar
```

### Use __*docker import*__ to create a new docker image based on this filesystem archive
- Restore a working Petalinunx Image from the archived container (using the one created in the above instructions)
```bash
bash:
$ docker import xlnx-petalinux-v2020.1_container_backup_02deadbeef91.tar xilinx-petalinux-imported:v2020.1
sha256:d5edcae92cab3d7ff6db8302f49f23aecb3e5c5beb80150332c4e2f8aae4f878
```

- List the local docker images
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-petalinux-imported        v2020.1              d5edcae92cab        20 seconds ago      9.76GB
xilinx-petalinux                 v2020.1              46f76f9e5d3d        19 hours ago        11.8GB
```

- See that the loaded image based on the filesystem archive has a clean history (knows nothing about how the filesystem was built)
```bash
$ docker history xilinx-petalinux-imported:v2020.1
IMAGE               CREATED             CREATED BY          SIZE                COMMENT
d5edcae92cab        40 seconds ago                          9.76GB              Imported from -            
```

- Create a running container based on the imported image
```bash
bash:
$ ../../../tools/bash/run_image_x11_macaddr.sh xilinx-petalinux-imported:v2020.1 xilinx_petalinux_imported_v2020.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-petalinux-imported:v2020.1
DOCKER_CONTAINER_NAME: xilinx_petalinux_imported_v2020.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
44e715b6477d9f762070653991143fad1557faa165823279f6df499bd2966111
```
