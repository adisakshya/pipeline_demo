#!/usr/bin/env bash

# Delete existing kind cluster
kind delete cluster

# Create new kind cluster from config file
kind create cluster --config=config/cluster-config.yml

# Run master playbook
echo '> Runing master playbook'
docker run --rm -it \
    -v "/$(pwd)/keys:/root/.ssh" \
    -v "/$(pwd)/ansible:/etc/ansible" \
    -v "/$(pwd):/ansible" \
    adisakshya/ansible:latest \
    ansible-playbook prerequisites.yml -i '//etc/ansible/hosts.yml'
