[//]: # (Readme.md - Redhat 8.2 host setup for docker)

# Installing Docker on Redhat 8.2
Quickly install and configure docker-ce on Redhat 8.2 to get started building xilinx development containers.

## Host Configuration

### Host Software Overview
- Redhat 8.2 (locked at minor release)
- Note: Redhat 8 is based on Fedora 28
  - https://docs.fedoraproject.org/en-US/quick-docs/fedora-and-red-hat-enterprise-linux/
- Note: Docker-CE for RHEL is only supported on IBM

### Docker Installation
- References
  - https://docs.docker.com/engine/install/fedora/
  - https://docs.docker.com/engine/install/rhel/
  - https://docs.docker.com/engine/install/centos/
  - https://linuxconfig.org/how-to-install-docker-in-rhel-8
  - 

### Add the CentOS Docker Repo to DNF
- Add the Docker repo to DNF
```bash
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```

- List the stable versions available
```bash
dnf list docker-ce --showduplicates | sort -r
  docker-ce.x86_64                3:20.10.9-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.8-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.7-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.6-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.5-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.4-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.3-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.2-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.17-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.16-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.15-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.14-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.1-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:20.10.13-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.12-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.11-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.10-3.el8                docker-ce-stable
  docker-ce.x86_64                3:20.10.0-3.el8                 docker-ce-stable
  docker-ce.x86_64                3:19.03.15-3.el8                docker-ce-stable
  docker-ce.x86_64                3:19.03.14-3.el8                docker-ce-stable
  docker-ce.x86_64                3:19.03.13-3.el8                docker-ce-stable
```

- Install docker-ce (attempt #1)
```bash
sudo dnf install docker-ce
  Error: 
   Problem: package docker-ce-3:20.10.17-3.el8.x86_64 requires containerd.io >= 1.4.1, but none of the providers can be installed
    - package containerd.io-1.4.10-3.1.el8.x86_64 conflicts with runc provided by runc-1:1.0.3-2.module+el8.6.0+14877+f643d2d6.x86_64

```

- See: https://unix.stackexchange.com/questions/611228/getting-series-of-file-conflicts-like-runc-and-containerd-when-trying-to-install
- Redhat has the [podman](https://podman.io/) and buildah[](https://buildah.io/) 
  - https://developers.redhat.com/blog/2019/02/21/podman-and-buildah-for-docker-users

- podman and buildah have package conflicts, so remove these first

```bash
sudo dnf remove podman buildah
  Dependencies resolved.
  ================================================================================================================================
   Package                Arch       Version                                          Repository                             Size
  ================================================================================================================================
  Removing:
   buildah                x86_64     1:1.24.2-4.module+el8.6.0+14877+f643d2d6         @rhel-8-for-x86_64-appstream-rpms      30 M
   podman                 x86_64     2:4.0.2-6.module+el8.6.0+14877+f643d2d6          @rhel-8-for-x86_64-appstream-rpms      51 M
  Removing dependent packages:
   cockpit-podman         noarch     43-1.module+el8.6.0+14877+f643d2d6               @rhel-8-for-x86_64-appstream-rpms     493 k
  Removing unused dependencies:
   conmon                 x86_64     2:2.1.0-1.module+el8.6.0+14877+f643d2d6          @rhel-8-for-x86_64-appstream-rpms     172 k
   container-selinux      noarch     2:2.179.1-1.module+el8.6.0+14877+f643d2d6        @rhel-8-for-x86_64-appstream-rpms      55 k
   containers-common      x86_64     2:1-27.module+el8.6.0+14877+f643d2d6             @rhel-8-for-x86_64-appstream-rpms     359 k
   criu                   x86_64     3.15-3.module+el8.6.0+14877+f643d2d6             @rhel-8-for-x86_64-appstream-rpms     1.4 M
   fuse-overlayfs         x86_64     1.8.2-1.module+el8.6.0+14877+f643d2d6            @rhel-8-for-x86_64-appstream-rpms     145 k
   fuse3                  x86_64     3.3.0-15.el8                                     @rhel-8-for-x86_64-baseos-rpms        100 k
   fuse3-libs             x86_64     3.3.0-15.el8                                     @rhel-8-for-x86_64-baseos-rpms        274 k
   libnet                 x86_64     1.1.6-15.el8                                     @AppStream                            166 k
   libslirp               x86_64     4.4.0-1.module+el8.6.0+14877+f643d2d6            @rhel-8-for-x86_64-appstream-rpms     134 k
   podman-catatonit       x86_64     2:4.0.2-6.module+el8.6.0+14877+f643d2d6          @rhel-8-for-x86_64-appstream-rpms     764 k
   runc                   x86_64     1:1.0.3-2.module+el8.6.0+14877+f643d2d6          @rhel-8-for-x86_64-appstream-rpms      11 M
   shadow-utils-subid     x86_64     2:4.6-16.el8                                     @rhel-8-for-x86_64-baseos-rpms        205 k
   slirp4netns            x86_64     1.1.8-2.module+el8.6.0+14877+f643d2d6            @rhel-8-for-x86_64-appstream-rpms      98 k

  Transaction Summary
  ================================================================================================================================
  Remove  16 Packages
```

### Verify the docker-ce installation is complete by running __*hello world*__ example
```bash
bash:
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:7d246653d0511db2a6b2e0436cfd0e52ac8c066000264b3ce63331ac66dca625
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

### Add your user to the docker group
```bash
bash:
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
  Redirecting to /bin/systemctl status docker.service
  ● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
     Active: active (running) since Sun 2022-09-04 13:11:00 EDT; 4s ago
       Docs: https://docs.docker.com
   Main PID: 12341 (dockerd)
      Tasks: 22
     Memory: 48.4M
     CGroup: /system.slice/docker.service
             └─12341 /usr/bin/dockerd --data-root=/docker --exec-root=/docker -H fd:// --containerd=/run/containerd/containerd.so>
```

## Configure Docker to Start on Boot
```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```
