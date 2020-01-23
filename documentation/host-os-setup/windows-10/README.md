
[//]: # (Readme.md - windows 10 host setup for docker)

# Installing Docker on Windows 10

## Host Configuration
There are two ways to configure a Windows 10 Host to work with Linux Docker containers. The instructions below setup your Windows 10 machine to support both workflows.

1.  Use Docker on Windows with Microsoft Powershell
- This requires maintenance of a separate set of powershell scripts for container manipulation

2.  Use Windows Subsystem for Linux to control Docker for Windows
- This requires configuration of Docker CLI with Ubuntu on Microsoft Windows Subsystem for Linux
- This allows you to use a unified set of scripts

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

## Turn on support for Hard/Soft link creation in Windows 10
- Install Developer Mode support
    - Right click the Windows Start Menu and select 'Settings'
    - Select 'Updates & Security'
    - Select 'For developers'
    - Under 'Use developer features', select 'Developer Mode'

## X-Windows Server Installation (VcXsrv)
- Highlights from https://sourceforge.net/projects/vcxsrv/

### VcXsrv Configuration (Post Installation)
- Download  VcXsrv
    - https://sourceforge.net/projects/vcxsrv/files/latest/download
- Install
    - Execute the installer
        - Example: 'vcxsrv-64.1.20.5.1.installer.exe'
- Reboot (if required)

### Run and Configure the X-Windows Server
- From the Windows Start Menu Select:
    - ```VcXsrv -> XLaunch```
- For Display Settings, Configure:
    - ```[*] Multiple Windows```
    - ```Display Number [-1]```
- For Client Startup, Configure:
    - ```[*] Start no client```
- For Extra Settings, Configure:
    - ```[X] Clipboard```
        - ```[X] Primary Selection```
    - ```[X] Native opengl```
    - ```[X] Disable access control```
- Save the configuration
    - Use default location: ```config.xlaunch```
- Finish configuration
- Check the Windows Taskbar for the XLaunch status icon
    - Hover over the icon to view X display assignment
        - Example: ```<Computer Name>:0.0 - 0 clients```

## Docker Installation
- Highlights from https://store.docker.com/editions/community/docker-ce-desktop-windows
- Download the Docker Community Edition Windows Installer (and Install)
    - https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe
- Install Docker Community Edition for Windows
    - Execute the __Docker for Windows Installer.exe__
- Reboot (if required)

# Configure Windows Powershell Workflow

## Enable Windows Powershell
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
- Reboot

## Configure Windows Powershell Workflow

### Powershell Security Policy Configuration (Post Installation)
- By default powershell scripts are disabled
- Reference documentation:
    - [Microsoft Powershell Execution Policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6)
        - [Get-ExecutionPolicy Command Reference](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-executionpolicy?view=powershell-6)
        - [Set-ExecutionPolicy Command Reference](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6)
- Configure the execution policy to allow local user scripts to be executed
```powershell
PS C:\Users\xilinx> Get-ExecutionPolicy -List

        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser       Undefined
 LocalMachine       Undefined


PS C:\Users\xilinx> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Execution Policy Change
The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
you to the security risks described in the about_Execution_Policies help topic at
https:/go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): A

PS C:\Users\xilinx> Get-ExecutionPolicy -List

        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned
 LocalMachine       Undefined
```

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

## Create a Local Windows 10 User Account to share files with Docker Containers
- Windows Start Menu -> Run
    - Type ```netplwiz``` to launch User Account configuration
- Launch the local user management interface
    - Select the 'Advanced' Tab
        - Under the 'Advanced user management' section click the ```Advanced``` button
- Select 'Users' under 'Local Users and Groups (Local)'
    - From the menu select 'Action -> New User'
        - Setup a Docker Host Account:
            - User Name: ```DockerHost```
            - Password/Confirm Password: ```<you choose>```
            - Uncheck: ```[ ] User must change password at next login```
            - Check: ```[X] User cannot change password```
            - Check: ```[X] Password never expires```
    - Complete user creation

### Share folders/files with docker account
- In File Explorer, right click the file or folder you want to share and select 'Properties'
- Select the 'Sharing' Tab
    - Select 'Advanced Sharing'
        - Select 'Permissions'
            - Click 'Add' and locate the ```DockerHost``` user
                - Give the user ```Full Control``` permissions of the shared drive
- Complete the sharing configuration
- When prompted by Docker, give Docker permission to use this DockerHost account to access shared folders inside of the container

# Configure Windows Subsystem for Linux - Docker for Windows workflow

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

## Install Ubuntu 18.04 on top of WSL
- More information on Ubuntu WSL can be found here:
    - https://wiki.ubuntu.com/WSL
- Get Ubuntu 18.04 for Windows 10 WSL:
    - https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q?activetab=pivot:overviewtab
- Launch Ubuntu once downloaded to complete installation and setup
    - The installer will launch a bash terminal
    - Setup a user account and password (Example: xilinx / xilinx)
```bash
Installing, this may take a few minutes...
Please create a default UNIX user account.  The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
Enter new UNIX username: xilinx
Enter new UNIX password: 
Retype new UNIX password: 
passwd: passsword upated successfully
Installation successful!
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

xilinx@DESKTOP-JPVULS8:~$
```
- Close the terminal session

### Grab the latest updates to Ubuntu
- Note: Package management on WSL is a manual process
    - Updates will not be downloaded and/or installed automatically
- Launch a Bash Terminal
    - 'Start Menu -> Run'
        - Type 'bash' to launch a bash shell
- Run 'sudo apt-get update' to pull down the latest pacakge updates
```bash
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get update
[sudo] password for xilinx:
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]

...

Get:28 http://archive.ubuntu.com/ubuntu bionic-backports/universe Translation-en [1900 B]
Fetched 18.2 MB in 28s (662 kB/s)
Reading package lists... Done
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$
```

- Check the Ubuntu version
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.2 LTS
Release:        18.04
Codename:       bionic
```

- Run 'sudo apt-get upgrade' to install the latest package updates
```bash
...
```selector-common
  libapt-inst2.0 libapt-pkg5.0 libbind9-160 libblkid1 libbz2-1.0 libcom-err2 libcurl3-gnutls libcurl4 libdb5.3
  libdbus-1-3 libdevmapper-event1.02.1 libdevmapper1.02.1 libdns-export1100 libdns1100 libdrm-common libdrm2 libelf1
  libexpat1 libext2fs2 libfdisk1 libgcc1 libgcrypt20 libglib2.0-0 libglib2.0-data libgnutls30 libidn2-0 libirs160
  libisc-export169 libisc169 libisccc160 libisccfg160 libldap-2.4-2 libldap-common liblvm2app2.2 liblvm2cmd2.02
  liblwres160 libmagic-mgc libmagic1 libmount1 libmspack0 libnss-systemd libpam-systemd libpcap0.8 libprocps6
  libpython3.6 libpython3.6-minimal libpython3.6-stdlib libseccomp2 libsmartcols1 libsqlite3-0 libss2 libssl1.1
  libstdc++6 libsystemd0 libudev1 libuuid1 libxslt1.1 libzstd1 lvm2 mount netplan.io nplan open-vm-tools openssl patch
  procps python3-apport python3-cryptography python3-distupgrade python3-gdbm python3-jinja2 python3-problem-report
  python3-software-properties python3.6 python3.6-minimal snapd software-properties-common sosreport sudo systemd
  systemd-sysv tmux tzdata ubuntu-minimal ubuntu-release-upgrader-core ubuntu-server ubuntu-standard udev
  unattended-upgrades update-notifier-common util-linux uuid-runtime vim vim-common vim-runtime vim-tiny xkb-data xxd
130 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
Need to get 58.9 MB of archives.
After this operation, 776 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y

...

Processing triggers for plymouth-theme-ubuntu-text (0.9.3-1ubuntu7.18.04.2) ...
update-initramfs: deferring update (trigger activated)
Processing triggers for initramfs-tools (0.130ubuntu3.9) ...
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$
```

- Check the Ubuntu version (which has been upgraded)
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.3 LTS
Release:        18.04
Codename:       bionic
```

### Configure how Windows Subsystem for Linux mounts external volumes
- This change the default mount point from '/<drive-letter>' to '/<drive-letter>' which matches how Docker for Windows handles shared volumes
- This will allow you to create containers with shared volumes that match docker for window
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo vi /etc/wsl.conf
[sudo] password for xilinx:
# Setup mount point for volumes
[automount]
root = /
options = "metadata"
```

- Restart your machine to have the new automount apply

### Install Docker inside of the Windows Subsystem for Linux
- Install Docker package dependencies
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
[sudo] password for xilinx:
Reading package lists... Done
Building dependency tree
Reading state information... Done
ca-certificates is already the newest version (20180409).
ca-certificates set to manually installed.
curl is already the newest version (7.58.0-2ubuntu3.8).
curl set to manually installed.
software-properties-common is already the newest version (0.96.24.32.12).
software-properties-common set to manually installed.
The following packages were automatically installed and are no longer required:
  libdumbnet1 libfreetype6
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  apt-transport-https
0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
Need to get 1692 B of archives.
After this operation, 153 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 apt-transport-https all 1.6.12 [1692 B]
Fetched 1692 B in 1s (2072 B/s)
Selecting previously unselected package apt-transport-https.
(Reading database ... 28678 files and directories currently installed.)
Preparing to unpack .../apt-transport-https_1.6.12_all.deb ...
Unpacking apt-transport-https (1.6.12) ...
Setting up apt-transport-https (1.6.12) ...
```

- Download and install Docker's PGP key
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
OK
```

- Verify Key fingerprint
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-key fingerprint 0EBFCD88
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

- Add the stable docker repository
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:2 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
```

- Update the apt package list
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get update -y
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:2 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
```

- Install Docker-CE in Windows Subsystem for Linux 
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get install -y docker-ce
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libdumbnet1 libfreetype6
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  aufs-tools cgroupfs-mount containerd.io docker-ce-cli libltdl7 pigz
The following NEW packages will be installed:
  aufs-tools cgroupfs-mount containerd.io docker-ce docker-ce-cli libltdl7 pigz
0 upgraded, 7 newly installed, 0 to remove and 2 not upgraded.
Need to get 85.5 MB of archives.
After this operation, 384 MB of additional disk space will be used.
Get:1 https://download.docker.com/linux/ubuntu bionic/stable amd64 containerd.io amd64 1.2.10-3 [20.0 MB]
...
Get:6 https://download.docker.com/linux/ubuntu bionic/stable amd64 docker-ce-cli amd64 5:19.03.5~3-0~ubuntu-bionic [42.5 MB]
Get:7 https://download.docker.com/linux/ubuntu bionic/stable amd64 docker-ce amd64 5:19.03.5~3-0~ubuntu-bionic [22.8 MB]Fetched 85.5 MB in 3s (31.2 MB/s)
...
Setting up docker-ce (5:19.03.5~3-0~ubuntu-bionic) ...
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
invoke-rc.d: could not determine current runlevel
Processing triggers for libc-bin (2.27-3ubuntu1) ...
Processing triggers for systemd (237-3ubuntu10.33) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for ureadahead (0.100.0-21) ...
```

- Give yourself docker permissions
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo usermode -aG docker $USER
```

- Close the Bash terminal

- Launch a new Bash Terminal
    - 'Start Menu -> Run'
        - Type 'bash' to launch a bash shell

- Verify that your user account is in the docker group
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ groups
xilinx adm dialout cdrom floppy sudo audio dip video plugdev lxd netdev docker
```

### Install Docker Compose in the Windows Subsystem for Linux
- Docker compose is available in two forms:
    - pre-built binary for linux
    - python package
- We're going to install the python version using pip
- Install python and pip in your Windows Subsystem for Linux
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get install python python-pip
[sudo] password for xilinx:
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libdumbnet1 libfreetype6
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
...
Setting up python-secretstorage (2.3.1-2) ...
Setting up python-keyring (10.6.0-1) ...
Setting up build-essential (12.4ubuntu1) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for mime-support (3.60ubuntu1) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...
```

- Install Docker compose
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ pip install --user docker-compose
Collecting docker-compose
  Downloading https://files.pythonhosted.org/packages/a3/05/cb792e714139a3f95e2ae85da74f2a327d6fd4a49753d35721539b9bcbfb/docker_compose-1.25.1-py2.py3-none-any.whl (138kB)
    100% |████████████████████████████████| 143kB 2.8MB/s
...
Installing collected packages: docopt, six, backports.ssl-match-hostname, texttable, setuptools, more-itertools, zipp, configparser, contextlib2, scandir, pathlib2, importlib-metadata, attrs, functools32, pyrsistent, jsonschema, dockerpty, subprocess32, enum34, cached-property, websocket-client, ipaddress, urllib3, certifi, chardet, idna, requests, backports.shutil-get-terminal-size, PyYAML, pycparser, cffi, pynacl, bcrypt, cryptography, paramiko, docker, docker-compose
Successfully installed PyYAML-3.13 attrs-19.3.0 ... docker-compose-1.25.1 ... websocket-client-0.57.0 zipp-1.0.0
```

## Configure your WSL path to include $Home/.local/bin
- Add the docker-compose installation path to your local shell path
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ cat ~/.profile
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add xilinx-docker repository scripts to path
export PATH="$PATH:/d/repositories/gitlab/xilinx-docker/tools/bash"

# Add docker compose in pip to the path
export PATH="$PATH:$HoME/.local/bin"
```

## Configure Docker for Windows to expose the daemon without requiring TLS
- In the system tray, right click the Docker whale icon and selec t 'Settings'
'Properties'
- Select the 'General' Tab
    - Check 'Expose daemon on tcp://localhost:2375 without TLS'
- Note: Docker will restart the daemon immediately

## Setup WSL to connect to Docker for Windows
- Setup the DOCKER_HOST environment variable in your bash resource file
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ echo \
"export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ cat ~/.bashrc
...
export DOCKER_HOST=tcp://localhost:2375
```

## Reload your profile and bashrc
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ source ~/.profile
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ source ~/.bashrc
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ echo $DOCKER_HOST
tcp://localhost:2375
```

## Docker Configuration (Post Installation)

### Verify the docker-ce installation is complete (by running hello world)
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete                                                                                             Digest: sha256:9572f7cdcee8591948c2963463447a53466950b3fc15a247fcad1917ca215a2f
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
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
fa4b966ac848        hello-world         "/hello"            36 seconds ago      Exited (0) 35 seconds ago                       fervent_liskov
```

- List the docker images
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              fce289e99eb9        12 months ago       1.84kB
```

- Remove the existing container(s) and image(s)
    - Use __*docker rm <CONTAINER_ID>*__ for containers
    - Use __*docker rmi <IMAGE_ID>*__ for images
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ docker rm fervent_liskov
fervent_liskov
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ docker rmi hello-world
Untagged: hello-world:latest
Untagged: hello-world@sha256:9572f7cdcee8591948c2963463447a53466950b3fc15a247fcad1917ca215a2f
Deleted: sha256:fce289e99eb9bca977dae136fbe2a82b6b7d4c372474c9235adc1741675f587e
Deleted: sha256:af0b15c8625bb1938f1d7b17081031f649fd14e6b233688eea3c5483994a66a3
```

# Miscellaneous notes and tips:

## Check WSL Disk Space Usage from a WSL Bash Shell
- Install NCDU
```bash
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ sudo apt-get install -y ncdu
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libdumbnet1 libfreetype6
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  ncdu
0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
Need to get 38.6 kB of archives.
After this operation, 93.2 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic/universe amd64 ncdu amd64 1.12-1 [38.6 kB]
Fetched 38.6 kB in 1s (77.2 kB/s)
Selecting previously unselected package ncdu.
(Reading database ... 36263 files and directories currently installed.)
Preparing to unpack .../archives/ncdu_1.12-1_amd64.deb ...
Unpacking ncdu (1.12-1) ...
Setting up ncdu (1.12-1) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
```

- Check disk usage of the actual WSL environment (exclude the windows mounted volumes)
- Note: This reports approximately 5GB total.
```bashrc
xilinx@DESKTOP-JPVULS8:/c/Windows/system32$ ncdu --exclude 
ncdu 1.12 ~ Use the arrow keys to navigate, press ? for help
--- /c/Windows/system32 --------------------------------------------------------------------------------------------
    2.1 GiB [##########] /DriverStore                                                                                     250.4 MiB [#         ] /winevt
. 171.7 MiB [          ] /drivers
. 148.9 MiB [          ] /spool
.  88.9 MiB [          ] /wbem
   62.8 MiB [          ] /catroot2
   62.7 MiB [          ]  MRT.exe
   59.2 MiB [          ] /CatRoot
   49.4 MiB [          ] /Intel
   48.7 MiB [          ] /en-US
   48.4 MiB [          ] /WinBioPlugIns
   46.4 MiB [          ] /migwiz
H  31.4 MiB [          ]  WindowsCodecsRaw.dll
   29.4 MiB [          ] /Macromed
   25.5 MiB [          ] /IME
H  24.7 MiB [          ]  edgehtml.dll
H  24.3 MiB [          ]  Hydrogen.dll
   21.7 MiB [          ] /spp
H  21.6 MiB [          ]  mshtml.dll
H  18.9 MiB [          ]  HologramWorld.dll
H  17.0 MiB [          ]  DXCaptureReplay.dll
H  17.0 MiB [          ]  Windows.UI.Xaml.dll
   16.5 MiB [          ] /F12
H  14.8 MiB [          ]  vmms.exe
   14.5 MiB [          ] /oobe
   13.4 MiB [          ] /Speech_OneCore
   13.1 MiB [          ] /DAX2
Total disk usage:   5.0 GiB  Apparent size:   5.0 GiB  Items: 17751                        
```

< === Experimental as of 1/22/2020 === > 

## Setup a SSTATE-MIRROR, SSTATE-CACHE and Petalinux Build folder on a Windows 10 Shared Folder
Note: The example below is for Petalinux v2019.2
Note: The example below uses the folder 'd:\srv\shared\sstate-mirrors\' on the Windows Filesystem to host the Mirror contents
- Download the shared state mirror bundle from Xilinx
    - https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html
- Example: v2019.2 Petalinux SSTATE-MIRROR
    - [aarch64 sstate-cache - 16.57 GB](https://www.xilinx.com/member/forms/download/xef.html?filename=sstate_aarch64_2019.2.tar.gz)
    - [arm sstate-cache - 8.54 GB](https://www.xilinx.com/member/forms/download/xef.html?filename=sstate_arm_2019.2.tar.gz)
    - [downloads - 22.29 GB](https://www.xilinx.com/member/forms/download/xef.html?filename=downloads_2019.2.tar.gz)

- Decompress the sstate mirror content into the folder shared with Docker
    - Do this through a WSL Bash Shell
    - This 

```bash
wsl:
xilinx@DESKTOP-JPVULS8:/d/xilinx/srv/sstate-mirrors$ mkdir -p sstate-rel-v2019.2
xilinx@DESKTOP-JPVULS8:/d/xilinx/srv/sstate-mirrors$ tar -zxvf sstate_aarch64_2019.2.tar.gz -C ./sstate-rel-v2019.2
...
sstate_aarch64_2019.2/aarch64/universal-4.8/cf/sstate:wayland-native:x86_64-linux:1.16.0:r0:x86_64:3:cfdf3b535e712aee35636fcdb1b6061d_populate_sysroot.tgz.siginfo
```

- Decompress the download mirror content into the folder shared with Docker

```bash
xilinx@DESKTOP-JPVULS8:/d/xilinx/srv/sstate-mirrors$ tar -zxvf downloads_2019.2.tar.gz -C ./sstate-rel-v2019.2
...
downloads/zlib-1.2.11.tar.xz
```

- Create a sstate-cache folder in the folder shared with Docker

```bash
xilinx@DESKTOP-JPVULS8:/d/xilinx/srv$ mkdir -p sstate-cache 
```

- Create a petalinux build folder in the folder shared with Docker

```bash
xilinx@DESKTOP-JPVULS8:/d/xilinx/srv$ mkdir -p petalinux
```

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
> docker run ... -v d:\xilinx\srv\sstate-mirrors:/srv/sstate-mirrors
```

```bash
wsl:
$ docker run ... -v /d/xilinx/srv/sstate-mirrors:/srv/sstate-mirrors
```

- Yocto sstate-cache

#### Example: Share the local yocto SSTATE cache
```powershell
powershell:
> docker run ... -v d:\xilinx\srv\sstate-cache\v2018.2:/srv/sstate-cache
```

```bash
wsl:
$ docker run ... -v /d/xilinx/srv/sstate-cache:/srv/sstate-cache
```

- Yocto downloads directory
  
#### Example: Share the local download directory
```powershell
bash:
> docker run ... -v d:\xilinx\srv\downloads\:/srv/downloads
```

```bash
wsl:
$ docker run ... -v /d/xilinx/srv/sstate-cache:/srv/sstate-cache
```

#### TFTP Server, Shared host folder
- TFTP Server Folder

#### Example: TFTP server folder 
```powershell
powershell:
> docker run ... -v d:\xilinx\srv\tftpboot:/tftpboot
```

- Shared host folder

#### Example: Shared host folder
```powershell
powershell:
> docker run ... -v d:\xilinx\srv\shared:/shared
```
