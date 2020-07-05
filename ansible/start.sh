#!/usr/bin/env bash

VERSION='1.0.3'
ENV='production'

# Run master playbook
echo '> Runing master playbook'
docker run --rm -it \
    -v "/$(pwd)/config:/etc/ansible" \
    -v "/$(pwd):/ansible" \
    adisakshya/ansible:latest \
    ansible-playbook site.yml --extra-vars "env=$ENV version=$VERSION" -i '//etc/ansible/hosts.yml'
