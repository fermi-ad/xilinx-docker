[//]: # (Readme.md - NVIDIA/CUDA:11.3.1-CUDNN8-RUNTIME-UBUNTU20.04 Docker Image)

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
| v3.0             | [Vitis-AI 3.0 Repo][vai30]    | [Dockerfile][vai30df] **[1][vai30dfn1] |

[vai30]: https://github.com/Xilinx/Vitis-AI/tree/3.0

[vai30df]: https://github.com/Xilinx/Vitis-AI/blob/08284f6e712eff0d12c65dbef3d1f074081a8027/docker/dockerfiles/ubuntu-vai/vitis-ai-cpu.Dockerfile#L4
[vai30dfn1]: https://github.com/Xilinx/Vitis-AI/blob/08284f6e712eff0d12c65dbef3d1f074081a8027/docker/docker_build.sh#L70

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
-t nvidia/cuda:11.3.1-base-ubuntu20.04 \
dist/11.3.1/ubuntu2004/base
```

3. Build the runtime image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.3.1/ubuntu2004/runtime/cudnn8
```

4. (Optional) Build the base runtime image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.3.1-runtime-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.3.1/ubuntu2004/runtime
```

5. (Optional) Build the developer image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.3.1-devel-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.3.1/ubuntu2004/devel
```

6. (Optional) Build the developer image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.3.1/ubuntu2004/devel/cudnn8
```

### Using Build Scripts (this repo)

1. Fetch the CUDA repo source

```bash
./fetch_depends.sh
```

- repo source
```bash
depends/cuda/dist/11.3.1/ubuntu2004/
├── base
│   └── Dockerfile
├── devel
│   ├── cudnn8
│   │   └── Dockerfile
│   └── Dockerfile
└── runtime
    ├── cudnn8
    │   └── Dockerfile
    └── Dockerfile

5 directories, 5 files
```

2. Build images
- Build the required base image and runtime image for Vitis-AI
```bash
./build_image.sh --base --runtime --cudnn --debug
	...
    REPOSITORY                            TAG                                 IMAGE ID       CREATED          SIZE
    nvidia/cuda                           11.3.1-cudnn8-runtime-ubuntu20.04   2cdd2ec437f6   20 seconds ago   3.31GB
    nvidia/cuda                           11.3.1-runtime-ubuntu20.04          46bcf7525427   10 minutes ago   1.86GB
    nvidia/cuda                           11.3.1-base-ubuntu20.04             af3e059c667e   11 minutes ago   126MB
```

- Build all images
```bash
./build_image.sh --all --debug
	...
	REPOSITORY                            TAG                                 IMAGE ID       CREATED          SIZE
    nvidia/cuda                           11.3.1-cudnn8-devel-ubuntu20.04     77f46a195987   6 minutes ago    8.96GB
    nvidia/cuda                           11.3.1-cudnn8-runtime-ubuntu20.04   2cdd2ec437f6   20 seconds ago   3.31GB
    nvidia/cuda                           11.3.1-devel-ubuntu20.04            77a05c60e178   8 minutes ago    4.94GB
    nvidia/cuda                           11.3.1-runtime-ubuntu20.04          46bcf7525427   10 minutes ago   1.86GB
    nvidia/cuda                           11.3.1-base-ubuntu20.04             af3e059c667e   11 minutes ago   126MB
```
