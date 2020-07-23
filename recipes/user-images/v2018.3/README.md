[//]: # (Readme.md - Base Ubuntu User Image for v2018.3 Xilinx Tools)

# Table of Contents

## Generate an Ubuntu Docker Image

- [Generate a base Ubuntu 16.04.4 image](#generate-a-base-ubuntu-16044-image)
- [Generate an Ubuntu 16.04.4 user image](#generate-an-ubuntu-16044-user-image)

## Working with the Ubuntu Docker Image

- [Create a working container](#create-a-working-container)
- [Interacting with a running container](#connect-to-the-running-container)

## Install Xilinx Tools in the Docker Container

- [Install Petalinux 2018.3](./README.user-install.md)
- [Install Vivado 2018.3](./README.vivado-install.md)
- [Install Vitis 2018.3](./README.vitis-install.md)

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
## Generate a base Ubuntu 16.04.4 image
- For Linux, execute the base image generation script __*../../base-images/ubuntu_16.04.4/build_image.sh*__

```bash
$ pushd ../../base-images/ubuntu-16.04.4/
$ ./build_image.sh 
Base Relese Image Download [Good] ubuntu-base-16.04.4-base-amd64.tar.gz
+ docker import depends/ubuntu-base-16.04.4-base-amd64.tar.gz ubuntu:16.04.4
sha256:3bd5992802b9074965bc53c89729792526bbe75e89f3a0aae71b97af52af68e7
+ docker image ls -a
REPOSITORY                       TAG                  IMAGE ID            CREATED                  SIZE
ubuntu                           16.04.4              3bd5992802b9        Less than a second ago   112MB

$ popd
```

## Generate Configuration Files (one time)

### Execute the configuration file generation script

- For Linux, execute the following script:
```bash
bash:
$ ./generate_configs.sh
```

- Follow the build process in the terminal (manual interaction required)
- Keyboard configuration
	- Select a keyboard model: ```Generic 105-key (Intl) PC``` is the default
	- Select a country of origin for the keyboard: ```English (US)``` is the default
	- Select a keyboard layout: ```English (US)``` is the default
	- Select an AltGr function: ```The default for the keyboard layout``` is the default
	- Select a compose key: ```No compose key``` is the default

- Review the generated configurations

```bash
bash:
-----------------------------------
Configurations Generated:
-----------------------------------
-rw-r--r-- 1 xilinx xilinx 1553 Jul 22 17:24 _generated/configs/keyboard_settings.conf
-----------------------------------

```

- Copy the generated configurations to the configuration folder

```bash
bash:
$ cp _generated/configs/* configs/
```

## Generate an Ubuntu 16.04.4 user image 
- This contains all the dependencies for the v2018.3 Xilinx Tools

### Configure build options
- Modify build options in the file __*./include/configuration.sh*__

### Execute the image build script
```bash
bash:
$ ./build_image.sh 
-----------------------------------
Checking for dependencies...
-----------------------------------
Base docker image [found] (ubuntu:16.04.4)
Keyboard Configuration: [Good] configs/keyboard_settings.conf
XTerm Configuration File: [Good] configs/XTerm
Minicom Configuration File: [Good] configs/.minirc.dfl
-----------------------------------

...

Removing intermediate container 662dae904442
 ---> 3dfc6437d7c9
Successfully built 3dfc6437d7c9
Successfully tagged xilinx-ubuntu-16.04.4-user:v2018.3
+ '[' 1 -ne 0 ']'
+ set +x
-----------------------------------
Shutting down Python HTTP Server...
-----------------------------------
Killing process ID 20764
-----------------------------------
+ kill 20764
+ '[' 1 -ne 0 ']'
+ set +x
./build_image.sh: line 171: 20764 Terminated              python3 -m http.server
-----------------------------------
Image Build Complete...
STARTED :Wed Jul 22 17:32:15 EDT 2020
ENDED   :Wed Jul 22 17:36:40 EDT 2020
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
xilinx-ubuntu-16.04.4-user       v2018.3              3dfc6437d7c9        2 hours ago         1.61GB
ubuntu                           16.04.4              8ce789b819ee        9 hours ago         112MB
```

### Create a working container

#### Run the helper script to create a working container

```bash
$ ../../../../tools/bash/run_image_x11_macaddr.sh xilinx-ubuntu-16.04.4-user:v2018.3 xilinx_user_v2018.3 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-ubuntu-16.04.4-user:v2018.3
DOCKER_CONTAINER_NAME: xilinx_user_v2018.3
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
0760f6f1643d5c56f6c95cf3ee1e4b95cf81659728e64671a1cbbf5033eda0c8

```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_user_v2018.3 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_user_v2018-3 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-16.04.4-user:v2018.3 \
	/bin/bash
fcd078a074d749ef41484a7c9ad319fb234a3d58a15d7238be3e67e6fcd894fd
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
fcd078a074d7        xilinx-ubuntu-16.04.4-user:v2018.3   "/bin/bash"         18 seconds ago      Up 17 seconds                           xilinx_user_v2018.3
```


```bash
$ docker inspect xilinx_user_v2018.3 | grep "MacAddress"            
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
$ docker exec -it xilinx_user_v2018.3 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2018-3:/$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_user_v2018.3
xilinx@xilinx_user_v2018-3:/$ xterm &
[1] 714
xilinx@xilinx_user_v2018-3:/$
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2018-3:/$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is `<CTRL> P+Q` (hold down the CTRL key, press P followed by Q)
```bash:
bash:
xilinx@xilinx_user_v2018-3:/$ read escape sequence
[1]+  Done                    docker exec -d xilinx_user_v2018.3 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED              STATUS              PORTS               NAMES
fcd078a074d7        xilinx-ubuntu-16.04.4-user:v2018.3   "/bin/bash"         About a minute ago   Up About a minute                       xilinx_user_v2018.3
```
