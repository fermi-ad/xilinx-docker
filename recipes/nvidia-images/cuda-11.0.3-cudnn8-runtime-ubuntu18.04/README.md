[//]: # (Readme.md - NVIDIA/CUDA:11.0.3-CUDNN8-RUNTIME-UBUNTU18.04 Docker Image)

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
| v2.5             | [Vitis-AI 2.5 Repo][vai25]    | [Dockerfile][vai25df]  |
| v2.0             | [Vitis-AI 2.0 Repo][vai20]    | [Dockerfile][vai20df]  |

[vai20]: https://github.com/Xilinx/Vitis-AI/tree/2.0
[vai25]: https://github.com/Xilinx/Vitis-AI/tree/2.5

[vai20df]: https://github.com/Xilinx/Vitis-AI/blob/d07ac7474f5f4c36575cbc3d0a31c509167a56b6/setup/docker/dockerfiles/vitis-ai-gpu.Dockerfile#L1
[vai25df]: https://github.com/Xilinx/Vitis-AI/blob/efe6bc9e1ab606f251cee87874e870871202ac99/docker/dockerfiles/vitis-ai-gpu.Dockerfile#L1

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
-t nvidia/cuda:11.0.3-base-ubuntu18.04 \
dist/end-of-life/11.0.3/ubuntu1804/base
```

3. Build the runtime image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.0.3-cudnn8-runtime-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/end-of-life/11.0.3/ubuntu1804/runtime/cudnn8
```

4. (Optional) Build the base runtime image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.0.3-runtime-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/end-of-life/11.0.3/ubuntu1804/runtime
```

5. (Optional) Build the developer image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.0.3-devel-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/end-of-life/11.0.3/ubuntu1804/devel
```

6. (Optional) Build the developer image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache --platform linux/x86_64 \
-t nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/end-of-life/11.0.3/ubuntu1804/devel/cudnn8
```

### Using Build Scripts (this repo)

1. Fetch the CUDA repo source

```bash
./fetch_depends.sh
```

- repo source
```bash
depends/cuda/dist/end-of-life/11.0.3/ubuntu1804/
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
	REPOSITORY                            TAG                                 IMAGE ID       CREATED             SIZE
    nvidia/cuda                           11.0.3-cudnn8-runtime-ubuntu18.04   d3ad1f4bf2e5   5 minutes ago       2.05GB
    nvidia/cuda                           11.0.3-runtime-ubuntu18.04          a85ebfe96579   5 minutes ago       2.05GB
    nvidia/cuda                           11.0.3-base-ubuntu18.04             8108103ccce9   6 minutes ago       111MB
```

- Build all images
```bash
./build_image.sh --all --debug
	...
    REPOSITORY                            TAG                                 IMAGE ID       CREATED             SIZE
    nvidia/cuda                           11.0.3-cudnn8-devel-ubuntu18.04     b4e8dcb04dda   4 minutes ago       3.97GB
    nvidia/cuda                           11.0.3-devel-ubuntu18.04            3953f9d1bbe6   4 minutes ago       3.97GB
    nvidia/cuda                           11.0.3-cudnn8-runtime-ubuntu18.04   d3ad1f4bf2e5   5 minutes ago       2.05GB
    nvidia/cuda                           11.0.3-runtime-ubuntu18.04          a85ebfe96579   5 minutes ago       2.05GB
    nvidia/cuda                           11.0.3-base-ubuntu18.04             8108103ccce9   6 minutes ago       111MB
```
