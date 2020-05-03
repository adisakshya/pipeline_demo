#!/usr/bin/env bash

# Delete existing kind cluster
kind delete cluster

# Create new kind cluster from config file
kind create cluster --config=config/cluster-config.yml
