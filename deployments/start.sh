#!/usr/bin/env bash

# Ping all hosts
echo '> Pinging all hosts'
docker run --rm -it \
    -v "/$(pwd)/keys:/root/.ssh" \
    -v "/$(pwd)/hosts:/etc/ansible" \
    adisakshya/ansible:latest \
    ansible all -m ping -i //etc/ansible/hosts.yml


ENV='production'

# Run master playbook
echo '> Runing master playbook'
docker run --rm -it \
    -v "/$(pwd)/keys:/root/.ssh" \
    -v "/$(pwd)/hosts:/etc/ansible" \
    -v "/$(pwd):/ansible" \
    adisakshya/ansible:latest \
    ansible-playbook site.yml --extra-vars "env=$ENV" -i //etc/ansible/hosts.yml 
