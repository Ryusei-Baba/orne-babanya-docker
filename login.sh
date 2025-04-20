#!/bin/bash
container_name="humble-devel"

if [ "$(docker ps -q -f name=$container_name)" ]; then
    docker exec -it $container_name bash
else
    echo "Starting container..."
    docker start -ai $container_name
fi
