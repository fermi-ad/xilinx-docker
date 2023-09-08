[//]: # (Readme.md - NVIDIA/CUDA:11.7.1-CUDNN8-DEVEL-UBUNTU20.04 Docker Image)

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
| v3.5             | [Vitis-AI 3.5 Repo][vai35]    | [Dockerfile][vai35df] **[1][vai35dfpt]  |

[vai35]: https://github.com/Xilinx/Vitis-AI/tree/3.5

[vai35df]: https://github.com/Xilinx/Vitis-AI/blob/7a0d5a695027b0dc1494c7299918959608c3fab2/docker/dockerfiles/ubuntu-vai/vitis-ai-cpu.Dockerfile#L4
[vai35dfpt]: https://github.com/Xilinx/Vitis-AI/blob/7a0d5a695027b0dc1494c7299918959608c3fab2/docker/docker_build.sh#L70
[vai35dftf]: https://github.com/Xilinx/Vitis-AI/blob/7a0d5a695027b0dc1494c7299918959608c3fab2/docker/docker_build.sh#L72

## Example worflow for building NVIDIA/CUDA images
- Note: Platform architecture in example commands is ```x86_64```
- Note: Additional architectures can be found in the [docker library/official-images README](https://github.com/docker-library/official-images#architectures-other-than-amd64)
- Note: 11.7.1 Docker recipes have been moved to the ```end-of-life``` sub-folder

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
-t nvidia/cuda:11.7.1-base-ubuntu20.04 \
dist/11.7.1/ubuntu2004/base
```

3. Build the developer image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.7.1/ubuntu2004/devel/cudnn8
```

4. (Optional) Build the base runtime image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.7.1-runtime-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.7.1/ubuntu2004/runtime
```

5. (Optional) Build the developer image
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.7.1-devel-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.7.1/ubuntu2004/devel
```

6. (Optional) Build the runtime image with CUDA Deep Neural Network tools
```bash
docker build \
--no-cache \
--platform linux/x86_64 \
-t nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04 \
--build-arg IMAGE_NAME=nvidia/cuda \
dist/11.7.1/ubuntu2004/runtime/cudnn8
```


### Using Build Scripts (this repo)

1. Fetch the CUDA repo source

```bash
./fetch_depends.sh
```

- repo source
```bash
depends/cuda/dist/11.7.1/ubuntu2004/
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
./build_image.sh --base --devel --cudnn --debug
	...
	REPOSITORY                            TAG                                 IMAGE ID       CREATED         SIZE
    nvidia/cuda                           11.7.1-cudnn8-devel-ubuntu20.04     404dbb455383   59 seconds ago      7.68GB
    nvidia/cuda                           11.7.1-devel-ubuntu20.04            6ad3ddb6227d   2 minutes ago       5.74GB
    nvidia/cuda                           11.7.1-base-ubuntu20.04             373ecda3417b   6 minutes ago       211MB
```

- Build all images
```bash
./build_image.sh --all --debug
	...
	REPOSITORY                            TAG                                 IMAGE ID       CREATED          SIZE
    nvidia/cuda                           11.7.1-cudnn8-devel-ubuntu20.04     404dbb455383   59 seconds ago      7.68GB
    nvidia/cuda                           11.7.1-devel-ubuntu20.04            6ad3ddb6227d   2 minutes ago       5.74GB
    nvidia/cuda                           11.7.1-cudnn8-runtime-ubuntu20.04   6859de225ac2   4 minutes ago       2.93GB
    nvidia/cuda                           11.7.1-runtime-ubuntu20.04          ce410047fb1f   5 minutes ago       2.03GB
    nvidia/cuda                           11.7.1-base-ubuntu20.04             373ecda3417b   6 minutes ago       211MB
```
