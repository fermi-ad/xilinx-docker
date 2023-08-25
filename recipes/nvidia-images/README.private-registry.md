# Run a simple private local registry for docker builds

## Run the registry
```bash
docker run -d -p 5000:5000 --name registry registry:2
	Unable to find image 'registry:2' locally
	2: Pulling from library/registry
	7264a8db6415: Pull complete 
	c4d48a809fc2: Pull complete 
	88b450dec42e: Pull complete 
	121f958bea53: Pull complete 
	7417fa3c6d92: Pull complete 
	Digest: sha256:e642e8604d305a3b82c8c1807b5df7a1a84cc650d57a60f9c5c2b78efec54b3f
	Status: Downloaded newer image for registry:2
	0134bb36b7754c3cce4a98ab84f798f3df615179f85db0a7e1397f6543ee7fac
```

- Check running
```bash
docker ps -a
	CONTAINER ID   IMAGE                                         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
	0134bb36b775   registry:2                                    "/entrypoint.sh /etc…"   26 seconds ago   Up 24 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry
```

- Tag image for pushing to locally hosted registry
```bash
docker tag ubuntu-iso:18.04.1 localhost:5000/ubuntu-iso:18.04.1
```

- Test pushing the tagged image to the locally hosted registry
```bash
docker push localhost:5000/ubuntu-iso:18.04.1
```

- Get a list of images in the locally hosted registry
```bash
curl -s -X GET http://localhost:5000/v2/_catalog | jq
{
  "repositories": [
    "ubuntu-iso"
  ]
}
```

- Get a list of tags (note this does not work due to network permissions issues)
```bash
curl -s -X GET https://localhost:5000/v2/ubuntu-iso/tags/list
```

## Add a registry mirror for to your local docker configuration
- See: https://docs.docker.com/registry/recipes/mirror/#configure-the-docker-daemon

### Manual method
- Edit ```/etc/docker/daemon.json``` and add:
```json
{
  "registry-mirrors": ["https://<my-docker-mirror-host>"]
}
```

### Using ```yq```
- See: https://github.com/mikefarah/yq
```bash
sudo yq e '.registry-mirrors += ["https://localhost:5000"]' -p json -i /etc/docker/daemon.json -o json
```

- Check the daemon configuration
```bash
yq /etc/docker/daemon.json -o json
	{
	  "runtimes": {
	    "nvidia": {
	      "args": [],
	      "path": "nvidia-container-runtime"
	    }
	  },
	  "registry-mirrors": [
	    "https://localhost:5000"
	  ]
	}
```
### Regstart the Daemon
```bash
sudo systemctl restart docker
```