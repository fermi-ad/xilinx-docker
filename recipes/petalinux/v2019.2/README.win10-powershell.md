[//]: # (Readme.win10.md - Using the Petalinux v2019.2 Build Environment on a Windows Host)

# Organization
```
-> .dockerignore
-> build_image.sh
-> generate_depends.sh
-> Dockerfile
-> autoinstall_petalinux.sh
-> configs/
	-> keyboard_settings.conf
	-> XTerm
-> depends/
	-> petalinux-v2019.2-final-installer.run
	-> mali-400-userspace.tar
-> include/
	-> configuration.sh
```

# Quickstart (PowerShell based Workflow)

## Create a working container (running in daemon mode) based on the petalinux image
- The examples below use helper scripts found in the xilinx-docker GIT repository
- The container is started in __interactive daemon__ mode
- You may also specify the MAC address of the container (making it easier to deal with tool licenses that are tied to a machine's MAC address)
- Note: For Windows Powershell, use __*Select-String*__  in place of __*grep*__ to find the MacAddress
- List the avaialble images
```powershell
PS D:\repositories\gitlab\xilinx-docker\tools\powershell> docker image ls                                                                                                                               REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
xilinx-petalinux    v2019.2             921da24fd087        2 months ago        26.7GB
```

- Create a running container using the helper script in the xilinx-docker repository tools folder
```powershell
PS D:\repositories\gitlab\xilinx-docker\tools\powershell> .\run_image_x11_macaddr.ps1 xilinx-petalinux:v2019.2 xilinx_petalinux_v2019.2 02:de:ad:be:ef:99                                               DOCKER_IMAGE_NAME: xilinx-petalinux:v2019.2
DOCKER_CONTAINER_NAME: xilinx_petalinux_v2019.2
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
DEBUG:   81+  >>>> $SERVER_IP = Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias 'vEthernet (DockerNAT)*'
...
DEBUG:   86+    >>>> Set-PSDebug -Trace 0
Setting DISPLAY=10.0.75.1:0.0
bdde4fa851863346648f18f117fe894817efb837c84145411f9fb1e2ea7abb0e
```

- List the running containers
```powershell
PS D:\repositories\gitlab\xilinx-docker\tools\powershell> docker ps -a                                                                                                                                  CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
bdde4fa85186        xilinx-petalinux:v2019.2   "/bin/bash"         58 seconds ago      Up 56 seconds                           xilinx_petalinux_v2019.2```
```

- Check that the mac address is set properly
```powershell
PS D:\repositories\gitlab\xilinx-docker\tools\powershell> docker inspect xilinx_petalinux_v2019.2 | Select-String "MacAddress"                                                                          
            "MacAddress": "02:de:ad:be:ef:99",
            "MacAddress": "02:de:ad:be:ef:99",
                    "MacAddress": "02:de:ad:be:ef:99",
```

## Connect to the running container
- There are two common ways to interact with the container
	- use __*docker attach*__ to use the container interactively with a shell session
		- To disconnect from an attached container but leave it running in the background, use the key combination `CTRL-P + CTRL-Q`
		- This method was used above to verify that the container was running
	- use __*docker exec*__ to execute commands in the container from the host OS command line
	- To disconnect from 


### (docker exec) Launch an xterm session in the running container from the host command line
- Launch an X-windows terminal shell for access to the container
```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

PS C:\Users\xilinx> docker exec -d xilinx_petalinux_v2019.2 bash -c "xterm"
```

- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.2'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$
```

- Close the xterm session
- Type 'exit' in the xterm session to close it

```bash
xterm:
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ exit
```

- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```powershell
PS C:\Users\xilinx> docker ps -a
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES
bdde4fa85186        xilinx-petalinux:v2019.2   "/bin/bash"         4 hours ago         Up 4 hours                              xilinx_petalinux_v2019.2
```

### (docker attach) Launch an xterm session after attaching to the running container
- This will launch a separate X-windows terminal session in your host OS
- This xterm session is not tied to a local terminal session
```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

PS C:\Users\rjmos> docker attach xilinx_petalinux_v2019.2
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ xterm &
[1] 604
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$
```

- This launches an X-windows terminal shell and sources the Petalinux settings script
```bash
xterm:
PetaLinux environment set to '/opt/Xilinx/petalinux/v2019.2'
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "PetaLinux SDK Installation Guide" for its impact and solution
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$
```

- Close the xterm session
- Type 'exit' in the xterm session to close it

```bash
xterm:
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ exit
```

- Detatch from the running container
	- You must use a special escape sequence to __*detach*__ from the running container to leave it running in the background
	- The special escape sequence is __*<CTRL-P> + <CTRL-Q>*__

```powershell
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ read escape sequence
PS C:\Users\xilinx>
```

- The container should still be running, even if the xterm session has been closed
- Verify that the container is still running in the background
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
da1efcfd4dd2        xilinx-petalinux:v2019.2   "/bin/bash"         29 seconds ago      Up 28 seconds                           xilinx_petalinux_v2019.2   768B (virtual 26.7GB)
```





< ==== UPDATE BELOW ==== >

# Petalinux Build Examples
- Show build examples for the following build configurations:
	1. Clean build entirely in running container, in user home folder
		- Build Stats:
			- Time: 44 minutes
			- Container Size: 18.2 GB
	2. Clean build with build folder in container, in user home folder, use tmpdir, sstate-mirror and sstate-cache on shared volume
		- Build Stats:
			- Time: 
			- Container Size: 
	3. Clean build with entire build folder on shared volume
		- Build Stats:
			- Time: 
			- Container Size: 

## Create a Petalinux build wrapper script to capture build time information
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~$ cat build_wrapper.sh
#!/bin/bash -v

# Capture build start time
_BUILD_START_TIME=`date`

petalinux-build

# Capture build end time
_BUILD_END_TIME=`date`

# Petalinux Image Build Complete
echo "-----------------------------------"
echo "Image Build Complete..."
echo "STARTED :"$_BUILD_START_TIME
echo "ENDED   :"$_BUILD_END_TIME
echo "-----------------------------------"
```

## Create a clean build entirely in the running container
- Check the size of the running container before creating a new project
- Note: Size of the current execution context is 2.31kb
- Note: The base petalinux docker container is 26.7GB in side
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
bdde4fa85186        xilinx-petalinux:v2019.2   "/bin/bash"         4 hours ago         Up 4 hours                              xilinx_petalinux_v2019.2   2.31kB (virtual 26.7GB)
```

- Create the project on a user folder inside of the container
```bash
xterm:
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ pushd ~/
/opt/Xilinx/petalinux/v2019.2
xilinx@xilinx_petalinux_v2019:~$ mkdir petalinux-build
xilinx@xilinx_petalinux_v2019:~$ cd petalinux-build/
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ petalinux-create -t project -n zcu106-clean -s /srv/software/bsps/xilinx-zcu106-v2019.2-final.bsp 
INFO: Create project: zcu106-clean
INFO: New project successfully created in /home/xilinx/petalinux-build/zcu106-clean
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ 
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 2.2GB!!!
```powershell
PS C:\Users\xilinx> docker container ls --size           
ID        			IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
bdde4fa85186        xilinx-petalinux:v2019.2   "/bin/bash"         5 hours ago         Up 5 hours                              xilinx_petalinux_v2019.2   2.2GB (virtual 28.9GB)
```

### Configure the Petalinux Build with defaults
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ cd zcu106-example/
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-example$ petalinux-config --silentconfig
[INFO] generating Kconfig for project
[INFO] silentconfig project
[INFO] sourcing bitbake
[INFO] generating plnxtool conf
[INFO] generating meta-plnx-generated layer
[INFO] generating user layers
[INFO] generating workspace directory
[INFO] generating bbappends for project . This may take time ! 
[INFO] generating u-boot configuration files
[INFO] generating kernel configuration files
[INFO] generating kconfig for Rootfs
[INFO] silentconfig rootfs
[INFO] generating petalinux-user-image.bb
[INFO] successfully configured project
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-example$ 
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 2.29GB.
```powershell
PS C:\Users\xilinx> docker container ls --size
ID        			IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
bdde4fa85186        xilinx-petalinux:v2019.2   "/bin/bash"         5 hours ago         Up 5 hours                              xilinx_petalinux_v2019.2   2.29GB (virtual 29GB)           
```

### Execute a clean build
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-example$ petalinux-build
[INFO] building project
[INFO] sourcing bitbake
[INFO] generating user layers
[INFO] generating workspace directory
INFO: bitbake petalinux-user-image
Loading cache: 100% |################################################################################################################################################################| Time: 0:00:02
Loaded 3979 entries from dependency cache.
Parsing recipes: 100% |##############################################################################################################################################################| Time: 0:00:07
Parsing of 2893 .bb files complete (2884 cached, 9 parsed). 3980 targets, 154 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies
Initialising tasks: 100% |###########################################################################################################################################################| Time: 0:00:13
Checking sstate mirror object availability: 100% |###################################################################################################################################| Time: 0:00:41
Sstate summary: Wanted 2182 Found 1713 Missed 938 Current 0 (78% match, 0% complete)
NOTE: Executing SetScene Tasks
NOTE: Executing RunQueue Tasks
NOTE: Tasks Summary: Attempted 6920 tasks of which 5099 didn't need to be rerun and all succeeded.
INFO: Copying Images from deploy to images
INFO: Creating /home/xilinx/petalinux-build/zcu106-example/images/linux directory
[Errno 21] Is a directory: '/home/xilinx/petalinux-build/zcu106-example/images/linux/pxelinux.cfg'
NOTE: Successfully copied built images to tftp dir: /tftpboot
[INFO] successfully built project
```

### Alternatively - Run the __*build_wrapper.sh*__ script to check build time
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-clean$ ./build_wrapper.sh 
#!/bin/bash -v

# Capture Build start time
_BUILD_START_TIME=`date`

petalinux-build
[INFO] building project
[INFO] sourcing bitbake
[INFO] generating user layers
[INFO] generating workspace directory
INFO: bitbake petalinux-user-image
Loading cache: 100% |###############################################################################| Time: 0:00:01
Loaded 3979 entries from dependency cache.
Parsing recipes: 100% |#############################################################################| Time: 0:00:06
Parsing of 2893 .bb files complete (2884 cached, 9 parsed). 3980 targets, 154 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies
Initialising tasks: 100% |##########################################################################| Time: 0:00:13
Checking sstate mirror object availability: 100% |##################################################| Time: 0:00:37
Sstate summary: Wanted 2182 Found 1713 Missed 938 Current 0 (78% match, 0% complete)
NOTE: Executing SetScene Tasks
NOTE: Executing RunQueue Tasks
NOTE: Tasks Summary: Attempted 6920 tasks of which 5099 didn't need to be rerun and all succeeded.
INFO: Copying Images from deploy to images
INFO: Creating /home/xilinx/petalinux-build/zcu106-clean/images/linux directory
[Errno 21] Is a directory: '/home/xilinx/petalinux-build/zcu106-clean/images/linux/pxelinux.cfg'
NOTE: Successfully copied built images to tftp dir: /tftpboot
[INFO] successfully built project

# Capture build end time

_BUILD_END_TIME=`date`

# Petalinux Image Build Complete
echo "--------------------------------"
--------------------------------
echo "Image Build Complete..."
Image Build Complete...
echo "STARTED  :"$_BUILD_START_TIME
STARTED  :Wed Jan 15 05:07:33 UTC 2020
echo "ENDED    :"$_BUILD_END_TIME
ENDED    :Wed Jan 15 05:51:29 UTC 2020
echo "--------------------------------"
--------------------------------
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 18.2GB with all of the build artifacts included!!!
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
da1efcfd4dd2        xilinx-petalinux:v2019.2   "/bin/bash"         11 hours ago        Up 11 hours                             xilinx_petalinux_v2019.2   18.2GB (virtual 44.9GB)
```

### Reset the running petalinux container
- Note: This will wipe out all of the build artifacts from this build
- Stop and remove the currently running container
```powershell
PS C:\Users\xilinx> docker stop xilinx_petalinux_v2019.2                                                                                                                                xilinx_petalinux_v2019.2
PS C:\Users\xilinx> docker rm xilinx_petalinux_v2019.2
xilinx_petalinux_v2019.2
```

- Create a new petalinux container
```powershell
PS C:\Users\xilinx> run_image_x11_macaddr.ps1 xilinx-petalinux:v2019.2 xilinx_petalinux_v2019.2 02:de:ad:be:ef:99 
DOCKER_IMAGE_NAME: xilinx-petalinux:v2019.2
DOCKER_CONTAINER_NAME: xilinx_petalinux_v2019.2
DOCKER_CONTAINER_MACADDR: 02:de:ad:be:ef:99
...
Setting DISPLAY=10.0.75.1:0.0
e8340baeeab23a94a601782a7dfcba9cd0604bab3353c79e98077627f698e91f
```

- Check the container size to see that it has been reset
```powershell
PS C:\Users\xilinx> docker container ls --size                                                                                                                                          CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
e8340baeeab2        xilinx-petalinux:v2019.2   "/bin/bash"         15 seconds ago      Up 14 seconds                           xilinx_petalinux_v2019.2   0B (virtual 26.7GB)
```

######################################################################################################

## Create a clean build with build folder in container and tmpdir, sstate-mirror and sstate-cache on shared volume
- Check the size of the running container before creating a new project
- Note: Size of the current execution context is 0B initially
- Note: The base petalinux docker container is 26.7GB in side
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
e8340baeeab2        xilinx-petalinux:v2019.2   "/bin/bash"         11 minutes ago      Up 11 minutes                           xilinx_petalinux_v2019.2   0B (virtual 26.7GB)
```

- Create the project on a user folder inside of the container
```bash
xterm:
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ pushd ~/
/opt/Xilinx/petalinux/v2019.2
xilinx@xilinx_petalinux_v2019:~$ mkdir petalinux-build
xilinx@xilinx_petalinux_v2019:~$ cd petalinux-build/
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ petalinux-create -t project -n zcu106-shared -s /srv/software/bsps/xilinx-zcu106-v2019.2-final.bsp 
INFO: Create project: zcu106-shared
INFO: New project successfully created in /home/xilinx/petalinux-build/zcu106-shared
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ 
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 2.2GB!!!
```powershell
PS C:\Users\xilinx> docker container ls --size           

```

### Configure the Petalinux Build with defaults
```bash
xterm:

```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 2.29GB.
```powershell
PS C:\Users\xilinx> docker container ls --size

```

### Execute a clean build
```bash
xterm:

```

### Alternatively - Run the __*build_wrapper.sh*__ script to check build time
```bash
xterm:

```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 18.2GB with all of the build artifacts included!!!
```powershell
PS C:\Users\xilinx> docker container ls --size

```

######################################################################################################3

## Create a clean build with entire build folder on shared volume
- Check the size of the running container before creating a new project
- Note: Size of the current execution context is 0B initially
- Note: The base petalinux docker container is 26.7GB in side
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
e8340baeeab2        xilinx-petalinux:v2019.2   "/bin/bash"         11 minutes ago      Up 11 minutes                           xilinx_petalinux_v2019.2   0B (virtual 26.7GB)
```

- Create the project on a user folder inside of the container
```bash
xterm:
xilinx@xilinx_petalinux_v2019:/opt/Xilinx/petalinux/v2019.2$ pushd ~/
/opt/Xilinx/petalinux/v2019.2
xilinx@xilinx_petalinux_v2019:~$ mkdir petalinux-build
xilinx@xilinx_petalinux_v2019:~$ cd petalinux-build/
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ petalinux-create -t project -n zcu106-shared -s /srv/software/bsps/xilinx-zcu106-v2019.2-final.bsp 
INFO: Create project: zcu106-shared
INFO: New project successfully created in /home/xilinx/petalinux-build/zcu106-shared
xilinx@xilinx_petalinux_v2019:~/petalinux-build$ 
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 2.2GB!!!
```powershell
PS C:\Users\xilinx> docker container ls --size           
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
e8340baeeab2        xilinx-petalinux:v2019.2   "/bin/bash"         36 minutes ago      Up 36 minutes                           xilinx_petalinux_v2019.2   2.2GB (virtual 28.9GB)
```

### Configure the Petalinux Build
- Configure the sstate feeds URL
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-shared$ petalinux-config
[INFO] generating Kconfig for project
[INFO] menuconfig project
```

#### Set menu configuration items
```
	: Yocto Settings -> TMPDIR Location 
		TMPDIR = (/srv/shared/petalinux/v2019.2/zcu106-shared/build/tmp)

	: Yocto Settings -> Local sstate feeds settings
		local sstate feeds url = (/srv/sstate-mirrors/sstate-rel-v2019.2/aarch64)
```

```bash
xterm:
configuration written to /home/xilinx/petalinux-build/zcu106-shared/project-spec/configs/config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

[INFO] sourcing bitbake
[INFO] generating plnxtool conf
[INFO] generating meta-plnx-generated layer
[INFO] generating user layers
[INFO] generating workspace directory
[INFO] generating bbappends for project . This may take time ! 
[INFO] generating u-boot configuration files
[INFO] generating kernel configuration files
[INFO] generating kconfig for Rootfs
[INFO] silentconfig rootfs
[INFO] generating petalinux-user-image.bb
[INFO] successfully configured project
```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context remained the same at 2.2GB.
```powershell
PS C:\Users\xilinx> docker container ls --size
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS               NAMES                      SIZE
e8340baeeab2        xilinx-petalinux:v2019.2   "/bin/bash"         45 minutes ago      Up 45 minutes                           xilinx_petalinux_v2019.2   2.2GB (virtual 28.9GB)
```

- Check the size of the temporary directory created on the shared volume
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-shared$ du -sh /srv/shared/petalinux/v2019.2/zcu106-shared/build/tmp
460K    /srv/shared/petalinux/v2019.2/zcu106-shared/build/tmp
```

### Set Download and SSTATE Cache Locations
- Edit the configuration file manually
```bash
xterm:
xilinx@xilinx_petalinux_v2019:~/petalinux-build/zcu106-shared$ vi build/conf/local.conf

		# Comment out original DL_DIR definition
		#DL_DIR = "${TOPDIR}/downloads"

		...

		# After including of conf/plnxtool.conf and conf/petalinuxbsp.conf
		# Override the Download Directory and Cache directories to a common location on my machine
		DL_DIR = "/srv/sstate-cache/v2019.2/zcu106-shared/downloads"
		SSTATE_DIR = "/srv/sstate-cache/v2019.2/zcu106-shared/sstate-cache"
```

### Execute a clean build
```bash
xterm:

```

### Alternatively - Run the __*build_wrapper.sh*__ script to check build time
```bash
xterm:

```

- Check the size of the container now with the newly created project
- Note: Size of the current execution context grew to 18.2GB with all of the build artifacts included!!!
```powershell
PS C:\Users\xilinx> docker container ls --size

```

######################################################################################################3


< ==== Modify Below ==== >


# Troubleshooting Builds on Windows

## Error: Case Insensitive File System when using a shared volume as TMPDIR
- As of April 2018, NTFS supports Case Sensitivity BUT only on a per-folder basis and this is disabled by default
	- See: https://devblogs.microsoft.com/commandline/per-directory-case-sensitivity-and-wsl/
```bash
xterm:
$ petalinux-build
...
INFO: bitbake petalinux-user-image
ERROR:  OE-core's config sanity checker detected a potential misconfiguration.
    Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
    Following is the list of potential problems / advisories:

    The TMPDIR (/srv/shared/petalinux/v2019.2/zcu106-shared/build/tmp) can't be on a case-insensitive file system.


Summary: There was 1 ERROR message shown, returning a non-zero exit code.
ERROR: Failed to build project
...
```

### Solution: Set the case sensitivity flag for the shared folder being used as TMPDIR

## Get started with a petalinux build (in the running container)

### Create a new project using a development board BSP (this example uses the ZCU106)
- Create the project on a shared folder outside of the container
```bash
bash:
xilinx@xlnx-petalinux-v2019.2:/opt/Xilinx/petalinux/v2019.2$ mkdir -p /srv/shared/petalinux/v2019.2/zcu106_example
xilinx@xlnx-petalinux-v2019.2:/opt/Xilinx/petalinux/v2019.2$ pushd /srv/shared/petalinux/v2019.2/zcu106_example/
xilinx@xlnx-petalinux-v2019.2:/srv/shared/petalinux/v2019.2/$ petalinux-create -t project -n projects/zcu106_example -s /srv/software/bsps/xilinx-zcu106-v2019.2-final.bsp
INFO: Create project: projects/zcu106_example
INFO: New project Successfully created in /srv/shared/petalinux/v2019.2/projects/zcu106_example
```

### Configure the Petalinux Build
```bash
bash:
xilinx@xlnx-petalinux-v2019.2:/srv/shared/petalinux/v2019.2/$ cd projects/zcu106_example
xilinx@xlnx-petalinux-v2019.2:/srv/shared/petalinux/v2019.2/projects/zcu106_example$ petalinux-config
[INFO] generating Kconfig for project
[INFO] menuconfig project
```

#### Configuration parameters (1)
- NOTE: SSTATE Mirror directory is located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - Petalinux sstate-mirror
    	- docker run argument: ```-v /srv/sstate-mirrors/sstate-rel-v2019.2/```
- Image Packaging Configuration -> tftpboot directory
	- /tftpboot/v2019.2/projects/zcu106_example
- Yocto Settings -> Parallel thread execution
	- BB_NUMBER_THREADS = 4
	- PARALLEL_MAKE = 4
- Yocto Settings -> Local sstate feeds settings
	- local sstate feeds url = /srv/sstate-mirrors/sstate-rel-v2019.2/aarch64

```bash
bash:
configuration written to /srv/shared/petalinux/v2019.2/projects/zcu106_example/project-spec/configs/config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

[INFO] sourcing bitbake
[INFO] generating plnxtool conf
[INFO] generating meta-plnx-generated layer
[INFO] generating bbappends for project . This may take time ! 
[INFO] generating u-boot configuration files
[INFO] generating kernel configuration files
[INFO] generating kconfig for Rootfs
[INFO] oldconfig rootfs
[INFO] generating petalinux-user-image.bb
[INFO] successfully configured project
xilinx@xilinx_petalinux_import_v2019.2:/srv/shared/petalinux/v2019.2/projects/zcu106_example$ 
```

#### Configuration parameters (2)
- NOTE: SSTATE Cache and Download Directories are located outside of the container (shared among containers) and mounted at run time using docker run arguments
    - docker run argument: ```-v /srv/sstate-cache/```
    - Petalinux sstate-mirror
    	- ```/srv/sstate-cache/v2019.2/```
    - Yocto sstate-cache download location
    	- ```-v /srv/sstate-cache/downloads/```
- These configuration are optional
- In the container, edit the file ./build/conf/local.conf
```bash
bash:
xilinx@xilinx_petalinux_import_v2019.2:/srv/shared/petalinux/v2019.2/projects/zcu106_example$ vi build/conf/local.conf
```
- Add the following optional configuration parameters at the end of the file:
```bash
# Use a shared SSTATE Cache Location
SSTATE_DIR ?= "/srv/sstate-cache/v2019.2"

# Turn on build history (disabled explicitly in Petalinux
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT="1"

# Use a shared DOWNLOAD directory
DL_DIR ?= "/srv/sstate-cache/downloads"
```

### Configuire the Petalinux Rootfs and Kernel
```bash
bash:
xilinx@xlnx-petalinux-v2019.2:/opt/Xilinx/petalinux/v2019.2/projects/zcu106_example$ petalinux-config -c rootfs
...
xilinx@xlnx-petalinux-v2019.2:/opt/Xilinx/petalinux/v2019.2/projects/zcu106_example$ petalinux-config -c kernel
...
```

### View the bitbake tasks associated with the recipe
```bash
bash:
xilinx@xilinx_petalinux_import_v2019.2:/srv/shared/petalinux/v2019.2/projects/zcu106_example$ petalinux-build -x listtasks
[INFO] building project
[INFO] sourcing bitbake
INFO: bitbake petalinux-user-image -c listtasks
Loading cache: 100% |#########################################################################################################################################################################################################| Time: 0:00:01
Loaded 3460 entries from dependency cache.
Parsing recipes: 100% |#######################################################################################################################################################################################################| Time: 0:00:05
Parsing of 2569 .bb files complete (2535 cached, 34 parsed). 3461 targets, 137 skipped, 0 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies
Initialising tasks: 100% |####################################################################################################################################################################################################| Time: 0:00:13
NOTE: Executing RunQueue Tasks
do_build                       Default task for a recipe - depends on all other normal tasks required to 'build' a recipe
do_build_without_rm_work       
do_checkuri                    Validates the SRC_URI value
do_checkuriall                 Validates the SRC_URI value for all recipes required to build a target
do_clean                       Removes all output files for a target
do_cleanall                    Removes all output files, shared state cache, and downloaded source files for a target
do_cleansstate                 Removes all output files and shared state cache for a target
do_compile                     Compiles the source in the compilation directory
do_configure                   Configures the source by enabling and disabling any build-time and configuration options for the software being built
do_devpyshell                  Starts an interactive Python shell for development/debugging
do_devshell                    Starts a shell with the environment set up for development/debugging
do_fetch                       Fetches the source code
do_fetchall                    Fetches all remote sources required to build a target
do_image                       
do_image_complete              
do_image_complete_setscene      (setscene version)
do_image_cpio                  
do_image_ext3                  
do_image_ext4                  
do_image_jffs2                 
do_image_qa                    
do_image_qa_setscene            (setscene version)
do_image_tar                   
do_install                     Copies files from the compilation directory to a holding area
do_listtasks                   Lists all defined tasks for a target
do_package                     Analyzes the content of the holding area and splits it into subsets based on available packages and files
do_package_qa_setscene         Runs QA checks on packaged files (setscene version)
do_package_setscene            Analyzes the content of the holding area and splits it into subsets based on available packages and files (setscene version)
do_package_write_rpm           Creates the actual RPM packages and places them in the Package Feed area
do_package_write_rpm_setscene  Creates the actual RPM packages and places them in the Package Feed area (setscene version)
do_packagedata                 Creates package metadata used by the build system to generate the final packages
do_packagedata_setscene        Creates package metadata used by the build system to generate the final packages (setscene version)
do_patch                       Locates patch files and applies them to the source code
do_populate_lic                Writes license information for the recipe that is collected later when the image is constructed
do_populate_lic_setscene       Writes license information for the recipe that is collected later when the image is constructed (setscene version)
do_populate_sdk                Creates the file and directory structure for an installable SDK
do_populate_sdk_ext            
do_populate_sysroot_setscene   Copies a subset of files installed by do_install into the sysroot in order to make them available to other recipes (setscene version)
do_prepare_recipe_sysroot      
do_rm_work                     Removes work files after the build system has finished with them
do_rm_work_all                 Top-level task for removing work files after the build system has finished with them
do_rootfs                      Creates the root filesystem (file and directory structure) for an image
do_rootfs_wicenv               
do_sdk_depends                 
do_unpack                      Unpacks the source code into a working directory
NOTE: Tasks Summary: Attempted 1 tasks of which 0 didn't need to be rerun and all succeeded.
INFO: Copying Images from deploy to images
INFO: Creating images/linux directory
NOTE: Successfully copied built images to tftp dir:  /tftpboot/v2019.2/projects/zcu106_example
[INFO] successfully built project
xilinx@xilinx_petalinux_import_v2019.2:/srv/shared/petalinux/v2019.2/projects/zcu106_example$ 
```
