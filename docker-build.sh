#!/bin/bash

# Import variables from .env file.
source ".env"

# Add lpweb git repository.
if ! git config remote.lpweb.url > /dev/null; then
    git remote add lpweb $LPWEB_REPO
fi

# Fetch all branches from lpweb repository.
git fetch lpweb --prune > /dev/null 2>&1
ALL_BRANCHES=()
LPWEB_BRANCHES=()
eval "$(git for-each-ref --shell --format='ALL_BRANCHES+=(%(refname:short))')"
for B in "${ALL_BRANCHES[@]}"; do
    [[ $B =~ "lpweb" ]] && LPWEB_BRANCHES+=(${B:6})
done
if [ ${#LPWEB_BRANCHES[@]} -eq 0 ]; then
    echo "Could not find any branches to build from."
    echo "Repo: ${LPWEB_REPO}"
    exit 1;
fi

# Ask which branch to build from.
PS3="?): "
echo "Select a branch to build from:"
select BUILD_BRANCH in ${LPWEB_BRANCHES[@]}; do
    [[ ! -z ${BUILD_BRANCH} ]] && break;
    echo "You must enter a valid number."
done
echo "Building from branch [$BUILD_BRANCH] ..."
echo

# Replace LPWEB_BRANCH environment variable with selected value in .env file.
SEARCH="LPWEB_BRANCH=.*"
REPLACE="LPWEB_BRANCH=${BUILD_BRANCH}"
sed -i -e "s/$SEARCH/$REPLACE/" ".env"
LPWEB_BRANCH=$BUILD_BRANCH

# Remove any lpweb containers previously created.
CONTAINERS=$(docker ps -a -q --filter name="lpweb*")
if [ "${#CONTAINERS[@]}" -ne 0 ]; then
    echo "Stop and remove lpweb containers ..."
    docker stop $CONTAINERS > /dev/null 2>&1
    docker rm $CONTAINERS > /dev/null 2>&1
fi

# Remove any lpweb volumes previously created.
VOLUMES=$(docker volume ls -q --filter name="lpweb*")
if [ "${#VOLUMES[@]}" -ne 0 ]; then
    echo "Remove lpweb volumes ..."
    docker volume rm $VOLUMES > /dev/null 2>&1
fi

# Remove any lpweb networks previously created.
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
echo "Application is up and running on branch [$LPWEB_BRANCH]."
echo "Check it out here: http://localhost:$PORT"
