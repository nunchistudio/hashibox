#!/bin/bash

# Make sure to include required environment variables.
source .env

# List all IP addresses running a Vault server.
IP_SERVERS=(
  192.168.60.10
  192.168.60.20
  192.168.60.30
)

# Unseal Vault on each known IP address.
for ip in "${IP_SERVERS[@]}"; do
  VAULT_ADDR=http://$ip:8200 vault operator unseal ${VAULT_UNSEAL_KEY} &> /dev/null
done
