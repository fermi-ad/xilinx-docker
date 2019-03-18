
[//]: # (Readme.md - windows 10 host setup for docker)

# Installing Docker on Windows 10

## Host Configuration

### Host Software Overview
- Windows 10
    - Windows Powershell
    - Windows Subsystem for Linux
- VcXsrv 64.1.20.1.3+
    - See: https://sourceforge.net/projects/vcxsrv/
- Python 3.5.3+ for Windows
    - See: https://www.python.org/downloads/windows/
- Docker v18.06.1-ce+
    - Note: As of docker v18.06.1-ce there is an issue with tar support for files > 8GB in size.
    - See: https://github.com/moby/moby/issues/37581

### Using link to dependencies in Windows
- Building a docker image with Xilinx tools requires the use of installer binaries that can be large
- By default, docker builds a context that inclues a cache of these installer files if they are in the working docker path during a build
- Although it's against the docker philosophy, using a link to a dependency which lives outside of the docker context can speed up the creation of your docker image and significantly reduce the amount of memory required to build and store an image
- For Windows Hosts, use the __*mklink <LINK_NAME> <TARGET>*__ command syntax to create a symbolic link in the __*./depends*__ directory

#### Example: Create a link to the Petalinux Installer __petalinux-v2018.2-final-installer.run__
- From a command prompt launched as __Administrator__
```cmd
command prompt:
> C:\checkouts\xilinx_docker> cd build_environments\v2018.2\depends
> C:\checkouts\xilinx_docker\build_environments\v2018.2\depends> mklink petalinux-v2018.2-final-installer.run S:\Xilinx\Downloads\petalinux-v2018.2-final-installer.run
```

### Special files/paths on host OS related to building embedded Linux
- These paths are specific to a host OS configuration and may be in different locations on other development machines.  The locations below reflect the setup of a reference development machine used in this repository.
- Sharing folders on the host filesystem with a container allows you to keep a single copy of important files (installers for instance) and reuse these across multiple development environments.
- To share folders you much enable 'File and Printer Sharing' in your firewall settings
    - Example: Norton Security v22.16+
        - Open Norton Security -> Settings -> Firewall
        - Open General Settings (Tab) -> Smart Firewall (Section) -> Public Network Exceptions (Configure[+])
        - Check 'Allow' for 'File and Printer Sharing'

#### SSTATE Mirrors, SSTATE Cache and Download Directory
- Petalinux sstate-mirror

#### Example: Share the local Petalinux SSTATE Mirror
```powershell
powershell:
> docker run argument: ```-v d:\srv\sstate-mirrors:/srv/sstate-mirrors
```

- Yocto sstate-cache

#### Example: Share the local yocto SSTATE cache
```powershell
powershell:
> docker run argument: ```-v d:\srv\sstate-cache\v2018.2:/srv/sstate-cache
```

- Yocto downloads directory
  
#### Example: Share the local download directory
```powershell
bash:
> docker run ... -v d:\srv\downloads\:/srv/downloads
```

#### TFTP Server, Shared host folder
- TFTP Server Folder

#### Example: TFTP server folder 
```powershell
powershell:
> docker run ... -v d:\srv\tftpboot:/tftpboot
```

- Shared host folder

#### Example: Shared host folder
```powershell
powershell:
> docker run ... -v d:\srv\shared:/shared
```

## Enable the Windows Subsystem for Linux and Windows Powershell
- Highlights from https://docs.microsoft.com/en-us/windows/wsl/install-win10
- Open the optional features menu
    - Method 1
        - Click on __Start Menu__
            - Type __optionalfeatures__
    - Method 2
        - Click on __Start Menu__
            - Select __Settings -> Apps__
            - On the right hand side, select __Programs and Features__ under Related settings
            - On the left hand side, select __Turn Windows features on or off__
- Enable Windows Powershell (if not already enabled)
    - Check 'Windows Powershell 2.0'

- Enable Windows Subsystem for Linux (of not already enabled)
    - Check 'Windows Subsystem for Linux'
- Reboot

## Turn on support for Hard/Soft link creation in Windows 10
- Install Developer Mode support
    - Right click the Windows Start Menu and select 'Settings'
    - Select 'Updates & Security'
    - Select 'For developers'
    - Under 'Use developer features', select 'Developer Mode'

## X-Windows Server Installation (VcXsrv)
- Highlights from https://sourceforge.net/projects/vcxsrv/

#### VcXsrv Configuration (Post Installation)
- Download  VcXsrv
    - https://sourceforge.net/projects/vcxsrv/files/latest/download
- Install
    - Execute the 'vcxsrv-64.1.20.1.3.installer.exe'
- Reboot (if required)

## Docker Installation
- Highlights from https://store.docker.com/editions/community/docker-ce-desktop-windows
- Download the Docker Community Edition Windows Installer (and Install)
    - https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe
- Install Docker Community Edition for Windows
    - Execute the __Docker for Windows Installer.exe__
- Reboot (if required)

## Docker Configuration (Post Installation)

### Verify the docker-ce installation is complete (by running hello world)
```powershell
powershell:
PS C:\Users\xilinx> docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
d1725b59e92d: Pull complete 
Digest: sha256:0add3ace90ecb4adbf7777e9aacf18357296e799f81cabc9fde470971e499788
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

### Remove the hello world docker container(s) and image(s)
- List the docker containers
```powershell
powershell:
PS C:\Users\xilinx> docker ps -a
CONTAINER ID        IMAGE                 COMMAND             CREATED              STATUS                          PORTS               NAMES
dde17ff03cac        hello-world           "/hello"            About a minute ago   Exited (0) About a minute ago                       cocky_lalande
bebe9a45e1da        hello-world           "/hello"            4 minutes ago        Exited (0) 4 minutes ago                            elated_lalande
```

- List the docker images
```command
PS C:\Users\xilinx> docker imagesREPOSITORY          TAG                      IMAGE ID            CREATED             SIZE
hello-world         latest                   4ab4c602aa5e        5 days ago          1.84kB
```

- Remove the existing container(s) and image(s)
	- Use __*docker rm <CONTAINER_ID>*__ for containers
    - Use __*docker rmi <IMAGE_ID>*__ for images
```powershell
powershell:
PS C:\Users\xilinx> docker rm dde17ff03cac
dde17ff03cac
> $ docker rm bebe9a45e1da
bebe9a45e1da

PS C:\Users\xilinx> docker rmi 4ab4c602aa5e
Untagged: hello-world:latest
Untagged: hello-world@sha256:0add3ace90ecb4adbf7777e9aacf18357296e799f81cabc9fde470971e499788
Deleted: sha256:4ab4c602aa5eed5528a6620ff18a1dc4faef0e1ab3a5eddeddb410714478c67f
Deleted: sha256:428c97da766c4c13b19088a471de6b622b038f3ae8efa10ec5a37d6d31a2df0b
```

# Miscellaneous notes and tips:

## Check the Windows Docker daemon log
- Open the Docker logfile
	- Right click on the Docker (whale) icon in the task bar and select 'Diagnose and Feedback'
	- Click the 'log file' link in the dialog box to open the log

## Change the location of docker's storage (cache, etc..)
- In Windows 10, Docker stores all files in a virtual Hyper-V drive (file).  To find and relocate this data store:
    - Stop the Windows Docker Service
        - Right click on the Docker (whale) icon in the task bar and select __Quit Docker__
        - Go into the Windows Task Manager and make sure Docker.Service is not running
        - If it is, stop it using the Task Manager
    - Use the Hyper-V Manager to detelte and relocate the default virtual disk/data store
    	- From the Windows Start Menu, type __Hyper-V Manager__
    	- In the left hand pane, select your PC (e.g. DESKTOP3HQ...)
    	- Under __Virtual Machines__, right click the __MobyLinuxVM__ and select __Delete__
    	- In the right hand pane, under __Actions__ select __Hyper-V Settings...__
    		- Under __Server__, set the path(s) for:
    			- Virtual Hard Disks: (ex: X:\devtools\hyper-v\Virtual Hard Disks)
    			- Virtual Machines: (ex: X:\devtools\hypeer-v)
    	- Select OK and exit the Hyper-V Manager
    - Relaunch the Docker Service
	   - From the Windows Start Menu, type __Docker for Windows__
	   - When prompted to restart the __Docker for Windows service__, select __Start__
    - Verify the new location of the Hyper-V virtual drive image:
    	- Right click on the Docker (whale) icon in the task bar and select __Settings__
    	- In the left hand pane, select __Advanced__
    	- Under __Disk image location__ note the location and name of the (.vhdx) file 
    		(ex: X:\devtools\hyper-v\Virtual Hard Disks\MobyLinuxVM.vhdx)

## Enable BuildKit (experimental feature in 18.06.x)
- Turn on experimental features (set {"experimental":true} in /etc/docker/daemon.json)
```powershell
powershell:
PS > Edit the file C:\Users\<username>\.docker\daemon.json
{
    "registry-mirrors": [],
    "insecure-registries": [],
    "debug": true,
    "experimental": true,
    "storage-driver": "overlay2",
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    }
}
```

- Enable Buildkit during a build (prefix 'docker build' with DOCKER_BUILDKIT=1)

```powershell
powershell:
PS > $ DOCKER_BUILDKIT=1 docker build ...
```
