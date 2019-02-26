#!/bin/bash
# docker__remove_containers.sh
echo "Stopping all docker containers..."
docker stop $(docker ps -aq)

echo "Removing all docker containers..."
docker rm $(docker ps -aq)
