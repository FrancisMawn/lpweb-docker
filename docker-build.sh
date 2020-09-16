#!/bin/bash

export $(cat .env | sed 's/#.*//g' | xargs)

CONTAINERS=$(docker ps -a -q --filter name="lpweb*")
if [ "${#CONTAINERS[@]}" -ne 0 ]; then
    echo "Stop and remove lpweb containers ..."
    docker stop $CONTAINERS > /dev/null 2>&1
    docker rm $CONTAINERS > /dev/null 2>&1
fi

VOLUMES=$(docker volume ls -q --filter name="lpweb*")
if [ "${#VOLUMES[@]}" -ne 0 ]; then
    echo "Remove lpweb volumes ..."
    docker volume rm $VOLUMES > /dev/null 2>&1
fi

NETWORKS=$(docker network ls -q --filter name="lpweb*")
if [ "${#NETWORKS[@]}" -ne 0 ]; then
    echo "Remove lpweb networks ..."
    docker network rm $NETWORKS > /dev/null 2>&1
fi

echo
echo "Build the application services ..."
docker-compose build --force --quiet

echo
echo "Instantiate the application containers ..."
docker-compose up -d

echo
echo "Installing CraftCMS ..."
docker exec -u nginx lpweb-docker_web_1 sh "/usr/share/nginx/install-craft.sh"

echo
echo "Application is up and running on branch [$BRANCH]."
echo "Check it out here: http://localhost:$PORT"
