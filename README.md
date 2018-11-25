# Requirements

docker-compose
docker

# How to use ?

## Setup the cluster

```bash
docker-compose up -d --scale manager=2 --scale worker=8
script/init-cluster.sh
```

Then you can enjoy your new swarm cluster available on

```bash
DOCKER_HOST=tcp://localhost:2375 docker node ls
```

## Tear down the cluster

```bash
docker-compose rm -sf
```

# How to deploy an image on the cluster ?

```
docker save yourimage > yourimage.tar
script/deploy-image.sh yourimage.tar
```
