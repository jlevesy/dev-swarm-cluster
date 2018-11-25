#!/bin/bash

set -eu

for CID in $(docker ps -f name=swarm -q); do
  docker cp ${1} ${CID}:/img.tar
  docker exec -ti ${CID} docker load -i /img.tar
done
