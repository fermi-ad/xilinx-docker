[//]: # (Readme.md - ubuntu 20.04 host setup for docker)

# Installing Docker on Ubuntu 20.04 (Focal Fossa)
Quickly install and configure docker-ce on Ubuntu 20.04 to get started building xilinx development containers.

## Host Configuration

### Host Software Overview
- Ubuntu 20,04.x LTS (Focal Fossa)
- Docker 19.03.12
  - Note: As of docker v18.06.1-ce there was an issue with tar support for files > 8GB in size.
  - See: https://github.com/moby/moby/issues/37581

## Docker Installation
- Taken from https://docs.docker.com/engine/install/ubuntu/

### Remove old versions of docker (if applicable)
```bash
bash:
$ sudo apt-get remove docker docker-ce docker-engine docker-io containerd runc
```

### Install packages so apt can use HTTPS:
```bash
bash:
$ sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common \
net-tools
```

### Install the docker GPG key
```bash
bash:
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

### Verify the fingerprint ending in OEBFCD88
```bash
bash:
$ sudo apt-key fingerprint 0EBFCD88
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

### Add the stable docker-ce repository
```bash
bash:
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
```

### Install the Docker Engine
```bash
bash:
$ sudo apt-get install docker-ce
### Check what versions of docker-ce are available
```bash
bash:
$ apt-cache madison docker-ce
 docker-ce | 5:19.03.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:19.03.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
```

### Install the latest version of the Docker Engine
```bash
bash:
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

#### Install an older (or specific) version of the Docker Engine
You may need to install an older version (for compatibility/stability) depending on your use.

Example: Install version 19.03.9
```bash
bash:
$ sudo apt-get install docker-ce=5:19.03.9~3-0~ubuntu-focal
```

### Verify the docker-ce installation is complete by running __*hello world*__ example
```bash
bash:
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:49a1c8800c94df04e9658809b006fd8a686cab8028d33cfba2cc049724254202
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## Docker Configuration (Post Installation)

### Create a docker user group and add your user to this group
```bash
bash:
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```

### Activate group changes (for your user account)
```bash
bash:
$ newgrp docker
```

### Check that you can run docker as a regular user (without sudo)
```bash
bash:
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### Remove the hello world docker container(s) and image(s)
- List the docker containers
```bash
bash:
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
9504b8f58c85        hello-world         "/hello"            50 seconds ago      Exited (0) 48 seconds ago                       distracted_feistel
dc9274500f7a        hello-world         "/hello"            2 minutes ago       Exited (0) 2 minutes ago                        optimistic_northcutt
```

- List the docker images
```bash
bash:
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              bf756fb1ae65        6 months ago        13.3kB
```

- Remove the existing container(s) and image(s)
  - Use 'docker rm <CONTAINER_ID>' for containers
  - Use 'docker rmi <IMAGE_ID>' for images

```bash
bash:
$ docker rm 9504b8f58c85 
9504b8f58c85 
$ docker rm dc9274500f7a
dc9274500f7a

$ docker rmi bf756fb1ae65
Untagged: hello-world:latest
Untagged: hello-world@sha256:49a1c8800c94df04e9658809b006fd8a686cab8028d33cfba2cc049724254202
Deleted: sha256:bf756fb1ae65adf866bd8c456593cd24beb6a0a061dedf42b26a993176745f6b
Deleted: sha256:9c27e219663c25e0f28493790cc0b88bc973ba3b1686355f221c38a36978ac63
```

## Provide docker container access to /dev/ttyUSB* devices
- Three requirements:
  - Add useraccount in container to the 'dialout' group
    - This is done in the Dockerfile recipe
```bash
bash:
$ sudo usermod -aG dialout <username>
```
  - Mount `/dev` from the host in the container
    - This allows you to always access dynamic /dev/tty* assigned devices
```bash
docker run \
...
  -v /dev:/dev \
...
```

  - Create the container with the right cgroup permissions
    - See the 'run_image_x11_macaddr.sh' shell script for how the -device-cgroup-rule is constructed on the fly when creating containers
```bash
...
  # Determine the CGROUP for /dev/ttyUSB* on the local host
  export DOCKER_TTYUSB_CGROUP=`ls -l /dev/ttyUSB* | sed 's/,/ /g' | awk '{print $5}' | head -n 1`
...
docker run \
...
  --device-cgroup-rule "c $DOCKER_TTYUSB_CGROUP:* rwm" \
...
```

# Miscellaneous notes and tips:

### Using links to dependencies
- Building a docker image with Xilinx tools requires the use of installer binaries that can be large
- By default, docker builds a context that includes a cache of these installer files if they are in the working docker path during a build
- Although it is against the docker philosophy, using a link to a dependency which lives outside of the docker context can speed up the creation of your docker image and significantly reduce the amount of memory required to build and store an image
- For Linux Hosts, use the __*ln -s <TARGET> <LINK_NAME>*__ command syntax to create a symbolic link in the __*./depends*__ directory

#### Example: Create a link to the Petalinux Installer __petalinux-v2018.2-final-installer.run__
```bash
bash:
$ cd build_environments/v2018.2/depends
$ ln -s /srv/xilinx/downloads/petalinux-v2018.2-final-installer.run petalinux-v2018.2-final-installer.run
```

### Special files/paths on host OS related to building embedded Linux
- These paths are specific to a host OS configuration and may be in different locations on other development machines.  The locations below reflect the setup of a reference development machine used in this repository.

#### X11 / Display Resources
- X11 Server Unix Domain Socket
  - This file allows the container to communicate with the Host OS Display (spawn X11-based applications within the container)

#### Example: Share the X11 display server unix domains socket
```bash
bash:
$ docker run ... -v /tmp/.X11-unix:/tmp/.X11-unix
```

#### SSTATE Mirrors, SSTATE Cache and Download Directory
- Petalinux sstate-mirror

#### Example: Share the local Petalinux SSTATE Mirror
```bash
bash:
$ docker run ... -v /srv/sstate-mirrors/sstate-rel-v2017.4/
```

- Yocto sstate-cache

#### Example: Share the local yocto SSTATE Cache
```bash
bash:
$ docker run ... -v /srv/sstate-cache/v2018.2/
```

- Yocto downloads directory

#### Example: Share the local download directory
```bash
bash:
$ docker run ... -v /srv/downloads/
```

#### TFTP Server, Shared host folder
- TFTP Server Folder

#### Example: TFTP server folder
```bash
bash:
$ docker run ... -v /srv/tftpboot:/tftpboot
```

- Shared host folder

#### Example: Shared host folder
```bash
bash:
$ docker run -v /srv/shared:/shared
```

## Check the Ubuntu 16.04+ docker daemon log
```bash
bash:
$ journalctl -u docker.service
```

## Check the docker daemon status
```bash
bash:
$ sudo sysctemctl is-active docker
    active
$ sudo service docker status
    docker.service - Docker Application Container Engine
       Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2018-08-29 16:23:41 EDT; 33min ago
   Docs: https://docs.docker.com
     Main PID: 5401 (dockerd)
  Tasks: 40
       CGroup: /system.slice/docker.service
         ├─5401 /usr/bin/dockerd -H fd://
         └─5426 docker-containerd --config /var/run/docker/containerd/containerd.toml

    Aug 29 16:24:31 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:24:31.986607981-04:00" level=info msg="No non-localhost
    Aug 29 16:24:31 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:24:31.986642407-04:00" level=info msg="IPv6 enabled; Ad
    Aug 29 16:24:32 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:24:32-04:00" level=info msg="shim docker-containerd-shi
    Aug 29 16:24:32 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:24:32-04:00" level=info msg="shim reaped" id=5307d2c39d
    Aug 29 16:24:32 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:24:32.477525675-04:00" level=info msg="ignoring event"
    Aug 29 16:33:09 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:33:09.752338020-04:00" level=info msg="No non-localhost
    Aug 29 16:33:09 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:33:09.752441404-04:00" level=info msg="IPv6 enabled; Ad
    Aug 29 16:33:09 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:33:09-04:00" level=info msg="shim docker-containerd-shi
    Aug 29 16:33:10 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:33:10-04:00" level=info msg="shim reaped" id=4152d1f9f7
    Aug 29 16:33:10 <MACHINE_NAME> dockerd[5401]: time="2018-08-29T16:33:10.333768846-04:00" level=info msg="ignoring event"
```

## Change the location of docker's storage (cache, etc..)

### Modify docker's startup script to define the new location:
- In: __*/lib/systemd/system/docker.service*__:
  - Note: The syntax changed from Docker 18.06 to 18.09

#### In Docker CE 18.09+
```
DEFAULT:
ExecStart=/usr/bin/dockerd -H unix://

NEW:
ExecStart=/usr/bin/dockerd --data-root=/new/docker/path --exec-root=/new/docker/path -H unix://
```

or

```
DEFAULT:
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

NEW:
ExecStart=/usr/bin/dockerd --data-root=/xilinx/docker --exec-root=/xilinx/docker -H fd:// --containerd=/run/containerd/containerd.sock
```

#### In Docker CE 18.06.1 (and earlier)
```
DEFAULT:
ExecStart=/usr/bin/docker daemon -H fd://

NEW:
ExecStart=/usr/bin/docker daemon -g /new/docker/path -H fd://
```

### Stop docker
```bash
bash:
$ systemctl stop docker
```

### Create the new path if it doesn't exist
```bash
bash:
$ mkdir /new/docker/path
```

### (Optional) If you have already been using docker and want to reuse images, containers and cache
```bash
bash:
$ sudo rsync -aX /var/lib/docker /new/docker/path
```

### Reload the new daemon configuration
```bash
bash:
$ systemctl daemon-reload
```

### Reload docker
```bash
bash:
$ systemctl start docker
```

### Check that docker is running in the new location
```bash
bash:
$ sudo service docker status
    docker.service - Docker Application Container Engine
       Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2018-08-29 16:23:41 EDT; 33min ago
   Docs: https://docs.docker.com
     Main PID: 5401 (dockerd)
  Tasks: 40
       CGroup: /system.slice/docker.service
         ├─5401 /usr/bin/dockerd -g /net/docker/path -H fd://
         └─5426 docker-containerd --config /var/run/docker/containerd/containerd.toml
```

## Enable BuildKit (experimental feature in 18.06.x)

### Turn on experimental features (set {"experimental":true} in /etc/docker/daemon.json)
```bash
bash:
$ sudo vi /etc/docker/daemon.json
...
{
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "experimental":true
}
```

### Enable Buildkit during a build (prefix 'docker build' with DOCKER_BUILDKIT=1)
```bash
bash:
$ DOCKER_BUILDKIT=1 docker build ...
```

## Remove Docker from your system (completely)

### Uninstall Docker
```bash
bash:
$ sudo apt-get purge -y docker docker-ce docker.io docker-engine
$ sudo apt-get autoremove -y --purge docker docker-ce docker.io docker-engine
```

### Remove remaining images, containers, volumes, configuration files and cache
```bash
bash:
$ sudo rm -rf /var/lib/docker
$ sudo rm -rf /etc/apparmor.d/docker
$ sudo groupdel docker
$ sudo rm -rf /var/run/docker.sock
```


< --- UPDATE ME BELOW AS OF 7/27/2020 --- >






