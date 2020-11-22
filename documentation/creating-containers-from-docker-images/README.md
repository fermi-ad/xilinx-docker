[//]: # (Readme.md - Creating Docker Containers from Docker Images)
 
# Table of Contents

## Create a working container (running in daemon mode) based on the user image
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress

### List images in the local docker repository
```bash
bash:
$ docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
xilinx-ubuntu-18.04.2-user   v2020.1             e95d2bfeeae2        1  minutes ago      2.26GB
ubuntu-iso                   18.04.2             6165bfac6800        30 minutes ago      243MB
```

### Create a working container

#### Run the helper script to create a working container

```bash
$ ../../../../tools/bash/run_image_x11_macaddr.sh xilinx-ubuntu-18.04.2-user:v2020.1 xilinx_user_v2020.1 02:de:ad:be:ef:91
DOCKER_IMAGE_NAME: xilinx-ubuntu-18.04.2-user:v2020.1
DOCKER_CONTAINER_NAME: xilinx_user_v2020.1
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:91
DOCKER_TTYUSB_CGROUP=188
access control disabled, clients can connect from any host
04391ade9972e89b9abd16251b367c5e75597aa01e56a9b6bb5546f891223d1c
```

#### Create a working container manually

```bash
$ docker run \
	--name xilinx_user_v2020.1 \
	--device-cgroup-rule "c 188:* rwm" \
	-h xilinx_user_v2020-1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ~/.Xauthority:/home/xilinx/.Xauthority \
	-v /srv/software/xilinx:/srv/software \
	-v /dev:/dev \
	-e DISPLAY=$DISPLAY \
	--mac-address "02:de:ad:be:ef:91" \
	--user xilinx \
	-itd xilinx-ubuntu-iso-18.04.2-user:v2020.1 \
	/bin/bash
4924fbeebe6f016b6e918d44a968fe5b5e89e42334a9fe2dc965a784d6d0c53f
```

#### Verify the container was created and the MAC Address was set properly

```bash
$ docker ps -a
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
3e285137eeb0        xilinx-ubuntu-18.04.2-user:v2020.1   "/bin/bash"         16 seconds ago      Up 14 seconds                           xilinx_user_v2020.1
```


```bash
$ docker inspect xilinx_user_v2020.1 | grep "MacAddress"            
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
$ docker exec -it xilinx_user_v2020.1 bash -c "xterm" &
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2020-1:/$
```

### Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```bash
bash:
$ docker attach xilinx_user_v2020.1
xilinx@xilinx_user_v2020-1:/$ xterm &
[1] 714
xilinx@xilinx_user_v2020-1:/$
```
- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
xilinx@xilinx_user_v2020-1:/$
```

### Close the xterm session
- Type 'exit' in the xterm session to close it
- If you attached to the running container first before launching xterm, you must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is `<CTRL> P+Q` (hold down the CTRL key, press P followed by Q)
```bash:
bash:
xilinx@xilinx_user_v2020-1:/$ read escape sequence
[1]+  Done                    docker exec -d xilinx_user_v2020.1 bash -c "xterm"
```
- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```bash
bash:
$ docker ps
CONTAINER ID        IMAGE                                COMMAND             CREATED             STATUS              PORTS               NAMES
3e285137eeb0        xilinx-ubuntu-iso-18.04.2-user:v2020.1   "/bin/bash"         2 minutes ago       Up 2 minutes                            xilinx_user_v2020.1
```
