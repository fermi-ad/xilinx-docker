#!/bin/bash
# define a function to list image tags in docker hub
# https://nickjanetakis.com/blog/docker-tip-81-searching-the-docker-hub-on-the-command-line
dtags () {
    local image="${1}"

    wget -q https://registry.hub.docker.com/v1/repositories/"${image}"/tags -O - \
        | tr -d '[]" ' | tr '}' '\n' | awk -F: '{print $3}'
}