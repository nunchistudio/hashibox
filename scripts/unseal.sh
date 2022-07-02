#!/bin/bash

set -euo pipefail

# List all IP address running a Vault server.
IP_SERVERS=(
  192.168.60.10
  192.168.60.20
  192.168.60.30
)

# Unseal Vault on each known IP address.
for ip in "${IP_SERVERS[@]}"; do
  curl --header "Content-Type: application/json" \
    --request POST \
    --data "{\"key\":\"${VAULT_UNSEAL_KEY}\"}" \
    http://$ip:8200/v1/sys/unseal
done
