#!/bin/bash
# docker__stop_containers.sh
echo "Stopping all docker containers..."
docker stop $(docker ps -aq)