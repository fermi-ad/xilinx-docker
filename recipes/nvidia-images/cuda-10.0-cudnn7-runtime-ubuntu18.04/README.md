[//]: # (Readme.md - NVIDIA/CUDA:10.0-CUDNN7-RUNTIME-UBUNTU18.04 Docker Image)

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

# NVIDIA/CUDA Docker Base Image Quickstart
- This image is used as a base for the following GPU-enabled Vitis-AI docker tool containers

| Vitis AI Release | Repository                    | GPU Dockerfile         |
|:-----------------|:------------------------------|:-----------------------|
| v1.4.1           | [Vitis-AI 1.4.1 Repo][vai141] | [Dockerfile][vai141df] |
| v1.4             | [Vitis-AI 1.4 Repo][vai14]    | [Dockerfile][vai14df]  |
| v1.3.2           | [Vitis-AI 1.3.2 Repo][vai132] | [Dockerfile][vai132df] |
| v1.3.1           | [Vitis-AI 1.3.1 Repo][vai131] | [Dockerfile][vai131df] |
| v1.2.1           | [Vitis-AI 1.2.1 Repo][vai121] | [Dockerfile][vai121df] |
| v1.2             | [Vitis-AI 1.2 Repo][vai12]    | [Dockerfile][vai12df]  |
| v1.1             | [Vitis-AI 1.1 Repo][vai11]    | [Dockerfile][vai11df]  |
| v1.0             | [Vitis-AI 1.0 Repo][vai10]    | [Dockerfile][vai10df]  |

[vai10]: https://github.com/Xilinx/Vitis-AI/tree/1.0
[vai11]: https://github.com/Xilinx/Vitis-AI/tree/1.1
[vai12]: https://github.com/Xilinx/Vitis-AI/tree/1.2
[vai121]: https://github.com/Xilinx/Vitis-AI/tree/1.2.1
[vai131]: https://github.com/Xilinx/Vitis-AI/tree/1.3.1
[vai132]: https://github.com/Xilinx/Vitis-AI/tree/1.3.2
[vai14]: https://github.com/Xilinx/Vitis-AI/tree/1.4
[vai141]: https://github.com/Xilinx/Vitis-AI/tree/1.4.1

[vai10df]: https://github.com/Xilinx/Vitis-AI/blob/f43ca6f2753c0345f79708eee670870457007a48/docker/Dockerfile.gpu#L10
[vai11df]: https://github.com/Xilinx/Vitis-AI/blob/67d20a0cf999796e3fff738bccdca3736f244f7e/docker/DockerfileGPU#L2
[vai12df]: https://github.com/Xilinx/Vitis-AI/blob/04a886ffb9f756958ee993f36ff52c1ad05d42a3/docker/DockerfileGPU#L2
[vai121df]: https://github.com/Xilinx/Vitis-AI/blob/91e7d4ef3ebbbd91ef787251c9a1414e152ce045/docker/DockerfileGPU#L2
[vai131df]: https://github.com/Xilinx/Vitis-AI/blob/ecdfc34b7ecf3a18696fa9c04ac7f226f37011fa/setup/docker/docker/DockerfileGPU#L1
[vai132df]: https://github.com/Xilinx/Vitis-AI/blob/6d306233c0d0f5cd88134d03218ce207dfa1959b/setup/docker/docker/DockerfileGPU#L1
[vai14df]: https://github.com/Xilinx/Vitis-AI/blob/f61061eef7550d98bf02a171604c9a9f283a7c47/setup/docker/docker/DockerfileGPU#L1
[vai141df]: https://github.com/Xilinx/Vitis-AI/blob/c6d79ee83ee940e83ececc9fac693fd9bf1a515c/setup/docker/docker/DockerfileGPU#L1


## Example worflow for building NVIDIA/CUDA images
- Note: Platform architecture in example commands is ```x86_64```
- Note: Additional architectures can be found in the [docker library/official-images README](https://github.com/docker-library/official-images#architectures-other-than-amd64)
- Note: 10.0 Docker recipes have been moved to the ```end-of-life``` sub-folder

### Manual Build Steps (complete commands)
- Steps 1-3 are required for Vitis-AI tools 
1. Clone the CUDA repo
```bash
git clone https://gitlab.com/nvidia/container-images/cuda.git
cd cuda
```

2. Build the base CUDA image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:10.0-base-ubuntu18.04 \
dist/end-of-life/10.0/ubuntu18/base
```

3. Build the runtime image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda dist/end-of-life/10.0/ubuntu18/runtime/cudnn7
```

4. (Optional) Build the base runtime image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:10.0-runtime-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda dist/end-of-life/10.0/ubuntu18/runtime
```

5. (Optional) Build the developer image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:10.0-devel-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda dist/end-of-life/10.0/ubuntu18/devel
```

6. (Optional) Build the developer image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda dist/end-of-life/10.0/ubuntu18/devel/cudnn7
```

### Using Build Scripts (this repo)

1. Fetch the CUDA repo source

```bash
./fetch_depends.sh
```

- repo source
```bash
depends/cuda/dist/end-of-life/10.0/ubuntu18/
├── base
│   └── Dockerfile
├── devel
│   ├── cudnn7
│   │   └── Dockerfile
│   └── Dockerfile
└── runtime
    ├── cudnn7
    │   └── Dockerfile
    └── Dockerfile

5 directories, 5 files
```

2. Build images
- Build the required base image and runtime image for Vitis-AI
```bash
./build_image.sh --base --runtime --cudnn --debug
	...
	REPOSITORY                            TAG                                 IMAGE ID       CREATED         SIZE
	nvidia/cuda                           10.0-cudnn7-runtime-ubuntu18.04     1bbe15d53b56   About a minute ago   1.37GB
	nvidia/cuda                           10.0-runtime-ubuntu18.04            7cd3f4bf52cc   About a minute ago   925MB
	nvidia/cuda                           10.0-base-ubuntu18.04               d8be8c6f2fa7   2 minutes ago        109MB
```

- Build all images
```bash
./build_image.sh --all --debug
	...
	REPOSITORY                            TAG                                 IMAGE ID       CREATED          SIZE
	nvidia/cuda                           10.0-cudnn7-devel-ubuntu18.04       68ddad11b0c7   5 minutes ago    3.31GB
	nvidia/cuda                           10.0-devel-ubuntu18.04              cdd3e8e61242   5 minutes ago    2.47GB
	nvidia/cuda                           10.0-cudnn7-runtime-ubuntu18.04     1bbe15d53b56   10 minutes ago   1.37GB
	nvidia/cuda                           10.0-runtime-ubuntu18.04            7cd3f4bf52cc   11 minutes ago   925MB
	nvidia/cuda                           10.0-base-ubuntu18.04               d8be8c6f2fa7   11 minutes ago   109MB
```
