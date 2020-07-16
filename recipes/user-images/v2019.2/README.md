[//]: # (Readme.md - Base Ubuntu User Image for v2019.2 Xilinx Tools)

# Table of Contents

## Generate an Ubuntu Docker Image

- [Generate a base Ubuntu 18.04.2 image](#generate-a-base-ubuntu-18042-image)
- [Generate an Ubuntu 18.04.2 user image](#generate-an-ubuntu-18042-user-image)

## Working with the Ubuntu Docker Image

- [Create a working container](#create-a-working-container)
- [Interacting with a running container](#connect-to-the-running-container)

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2019.2](./README.user-install.md)
- [Install Vivado 2019.2](./README.vivado-install.md)
- [Install Vitis 2019.2](./README.vitis-install.md)

## Additional References

- [Backup and Sharing of Docker Containers and Images](../../../documentation/backup-and-sharing-docker-images/README.md)

# Organization
```
-> .dockerignore
-> build_image.sh
-> Dockerfile
-> configs/
	-> .minirc.dfl
	-> keyboard_settings.conf
	-> XTerm
-> include/
	-> configuration.sh
```

# Quickstart
## Generate a base Ubuntu 18.04.2 image
- For Linux, execute the base image generation script __*../../base-images/ubuntu_18.04.2/build_image.sh*__

```bash
$ ./build_image.sh 
Base Release Image [Good] ubuntu-base-18.04.2-base-amd64.tar.gz
+ docker import depends/ubuntu-base-18.04.2-base-amd64.tar.gz ubuntu:18.04.2
sha256:76df73440f9c444f3397d23ad0f33339337c9061dfe2d4a8f52378e3704da71d
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           18.04.2              76df73440f9c        Less than a second ago   88.3MB
+ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   88.3MB              0B (0%)
Containers          0                   0                   0B                  0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
+ '[' 1 -ne 0 ']'
+ set +x

```

## Generate an Ubuntu 18.04.2 user image 
- This contains all the dependencies for the v2019.2 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:18.04.2)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container 1e880f204c83
 ---> 7af5c40d781f
Successfully built 7af5c40d781f
Successfully tagged xilinx-ubuntu-18.04.2-user:v2019.2
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 15057
-----------------------------------
+ kill 15057
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 15057 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 15 16:13:34 EDT 2020
ENDED   :Wed Jul 15 16:19:30 EDT 2020
-----------------------------------
```

## Create a working container (running in daemon mode) based on the user image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                       TAG                  IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.2-user       v2019.2              7af5c40d781f        3 minutes ago       2.02GB
ubuntu                           18.04.2              76df73440f9c        12 days ago         88.3MB
```

### Create a working container

#### Run the helper script to create a working container

```bash
$ ../../../../tools/bash/run_image_x11_macaddr.sh xilinx-ubuntu-18.04.2-user:v2019.2 xilinx_user_v2019.2 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-ubuntu-18.04.2-user:v2019.2
DOCKER_CONTAINER_NAME: xilinx_user_v2019.2
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
a2a8c3a46ee4c81192a5282046a80b291aeefd64829d2e104b4fc6de4ddf583f
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_user_v2019.2 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_user_v2019-2 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-18.04.2-user:v2019.2 \
	/bin/bash
4924fbeebe6f016b6e918d44a968fe5b5e89e42334a9fe2dc965a784d6d0c53f
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
3e285137eeb0        xilinx-ubuntu-18.04.2-user:v2019.2   "/bin/bash"         16 seconds ago      Up 14 seconds                           xilinx_user_v2019.2
```


```bash
$ docker inspect xilinx_user_v2019.2 | grep "MacAddress"            
 	"MacAddress": "02:de:ad:be:ef:91",
    "MacAddress": "02:de:ad:be:ef:91",
    	"MacAddress": "02:de:ad:be:ef:91"
```

#### Examine the syntax of the example `docker run` command
```bash
docker run \
	--name $DOCKER_CONTAINER_NAME \
	--device-cgroup-rule "c $DOCKER_TTYUSB_CGROUP:* rwm" \
	-h $DOCKER_CONTAINER_NAME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address $DOCKER_CONTAINER_MACADDR \
	--user xilinx \
	-itd $DOCKER_IMAGE_NAME \
	/bin/bash
```

##### Name the Docker Container
- Give the docker container a name
- If this is not specified, docker will randomly name the created container

```
	--name $DOCKER_CONTAINER_NAME \
```

##### Setup Control Group for Docker Access to /dev/ttyUSB devices
- Setup CGROUP rules so Docker containers can share host resources

```
	--device-cgroup-rule "c $DOCKER_TTYUSB_CGROUP:* rwm" \
```

- The cgroup number for /dev/ttyUSB0 below is `188` provided in the file listing
```bash
$ ls -al /dev/ttyUSB*
crw-rw---- 1 root dialout 188,  0 Jul  5 13:57 /dev/ttyUSB0
```

- You can get this programmatically using `sed` and `awk`
```bash
$ export DOCKER_TTYUSB_CGROUP=`ls -l /dev/ttyUSB* | sed 's/,/ /g' | awk '{print $5}' | head -n 1`
```

##### X-Windows Host OS Support
- Allow the docker container to launch X-windows sessions on the Host OS
- X-Windows clients in the Docker container communicate to the host X-Windows server through the Unix domain socket `/tmp/.X11-unix/X0`
- X-Windows clients use the credentials in the `~/.Xauthority` file to authenticate X-Windows sessions

```
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-e DISPLAY=$DISPLAY \
```

##### Share a host folder with the Docker Container
- Allow the docker container to access a host OS folder
- This is how you can share the Xilinx tool installers (and other files) with the Docker container without including them in the container

```
	-v /srv/software/xilinx:/srv/software \
```

##### Mount `/dev` so the container can access `/dev/ttyUSB` devices
- Allow the container access to USB serial ports

```
	-v /dev:/dev \
```

##### Assign an Ethernet MAC Address to the container
- Specify an Ethernet MAC Address (can be associated with tool licenses)

```
	--mac-address $DOCKER_CONTAINER_MACADDR \
```

##### Set the user in the container to the `xilinx` user 

```
	--user xilinx \
```

##### Execute a bash shell in the Container in interactive daemon mode

```
	-itd $DOCKER_IMAGE_NAME \
	/bin/bash
```

## Connect to the running container
- There are two common ways to interact with the container
	- use __*docker attach*__ to use the container interactively with a shell session
		- This method was used above to verify that the container was running
	- use __*docker exec*__ to execute commands in the container from the host OS command line

### Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```bash
bash:
$ docker exec -it xilinx_user_v2019.2 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2019-2:/$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_user_v2019.2
xilinx@xilinx_user_v2019-2:/$ xterm &
[1] 714
xilinx@xilinx_user_v2019-2:/$
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2019-2:/$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is `<CTRL> P+Q` (hold down the CTRL key, press P followed by Q)
```bash:
bash:
xilinx@xilinx_user_v2019-2:/$ read escape sequence
[1]+  Done                    docker exec -d xilinx_user_v2019.2 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
3e285137eeb0        xilinx-ubuntu-18.04.2-user:v2019.2   "/bin/bash"         2 minutes ago       Up 2 minutes                            xilinx_user_v2019.2
```
