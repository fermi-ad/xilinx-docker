#!/bin/bash
# docker__remove_images.sh
echo "Removing docker images..."
docker image rm $(docker image ls -aq)
