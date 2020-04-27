#!/usr/bin/env bash

# Ping all hosts
echo '> Pinging all hosts'
docker run --rm -it \
    -v "/$(pwd)/keys:/root/.ssh" \
    -v "/$(pwd)/hosts:/etc/ansible" \
    -v "/$(pwd)/playbooks:/ansible/playbooks" \
    adisakshya/ansible:latest \
    ansible all -m ping -i //etc/ansible/hosts.yml

# Run ping playbook on all hosts
echo '> Runing ping playbook on all hosts'
docker run --rm -it \
    -v "/$(pwd)/keys:/root/.ssh" \
    -v "/$(pwd)/hosts:/etc/ansible" \
    -v "/$(pwd)/playbooks:/ansible/playbooks" \
    adisakshya/ansible:latest \
    ansible-playbook playbooks/ping.yml -i //etc/ansible/hosts.yml