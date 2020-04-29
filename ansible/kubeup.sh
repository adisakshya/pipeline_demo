#!/usr/bin/env bash

# Prune docker containers
echo '> Pruning docker containers'
docker container prune -f

# Setup Kubernetes Master Node
echo '> Setting up Kubernets Master node'
docker run -d --privileged -p 2223:22 \
    --name K8Master \
    -v "/$(pwd)/keys/ansible.pub:/home/ubuntu/.ssh/authorized_keys" \
    --memory="1024m" --memory-swap="1024m" \
    adisakshya/ssh-service:latest \
    && ssh-copy-id -f  -i keys/ansible root@192.168.99.101 -p 2223

# Setup Kubernetes Worker Node 1
echo '> Setting up Kubernets Worker node 1'
docker run -d --privileged -p 2224:22 \
    --name k8Worker1 \
    -v "/$(pwd)/keys/ansible.pub:/home/ubuntu/.ssh/authorized_keys" \
    --memory="1024m" --memory-swap="1024m" \
    adisakshya/ssh-service:latest \
    && ssh-copy-id -f  -i keys/ansible root@192.168.99.101 -p 2224