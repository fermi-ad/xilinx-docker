#!/bin/bash
# docker__remove_images.sh
echo "Removing dangling <none> docker images..."
docker image rm $(docker image ls -f "dangling=true" -aq)
