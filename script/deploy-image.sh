#!/bin/bash

set -eu -o pipefail

for CID in $(docker ps -f name=swarm -q); do
  docker cp "${1}" "${CID}:/img.tar" &
done

wait

for CID in $(docker ps -f name=swarm -q); do
  docker exec -t "${CID}" docker load -i "/img.tar" &
done

wait
