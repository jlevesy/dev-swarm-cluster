#!/bin/bash

set -eu

function control_docker() {
  DOCKER_HOST=tcp://localhost:2375 docker "$@"
}

function docker_exec() {
  docker exec -t "$@"
}

echo "Initializing the swarm..."

control_docker swarm init
MANAGER_JOIN_TOKEN=$(control_docker swarm join-token manager --quiet)
WORKER_JOIN_TOKEN=$(control_docker swarm join-token worker --quiet)
MANAGER_IP=$(control_docker info -f "{{.Swarm.NodeAddr}}")

echo "Setuping masters..."

for CID in $(docker ps -f name=manager -q); do
  docker_exec "${CID}" docker swarm join --token "${MANAGER_JOIN_TOKEN}" "${MANAGER_IP}:2377" &
done

wait

echo "Setuping workers..."

for CID in $(docker ps -f name=worker -q); do
  docker_exec "${CID}" docker swarm join --token "${WORKER_JOIN_TOKEN}" "${MANAGER_IP}:2377" &
done

wait

echo "All is good, enjoy your new swarm cluster !"

control_docker node ls
