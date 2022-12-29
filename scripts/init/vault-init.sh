#!/bin/bash

# Initialize Vault. Save the unseal key and root token.
init=$(VAULT_ADDR=http://192.168.60.10:8200 vault operator init --format=json -key-shares=1 -key-threshold=1)
unsealKey=$(jq -r .unseal_keys_b64[0] <<< "${init}")
rootToken=$(jq -r .root_token <<< "${init}")

# Export the unseal key and root token as environment variables.
{
  echo "export VAULT_UNSEAL_KEY=${unsealKey}" | tee -a ./.env
  echo "export VAULT_TOKEN=${rootToken}" | tee -a ./.env
} &> /dev/null

# Unseal the Vault server that has been initialized.
VAULT_ADDR=http://192.168.60.10:8200 vault operator unseal ${unsealKey} &> /dev/null

# List other IP addresses running a Vault server.
IP_SERVERS=(
  192.168.60.20
  192.168.60.30
)

# For each other Vault server, configure Raft to join the cluster and unseal it.
for ip in "${IP_SERVERS[@]}"; do
  {
    VAULT_ADDR=http://$ip:8200 vault operator raft join http://192.168.60.10:8200
    VAULT_ADDR=http://$ip:8200 vault operator unseal ${unsealKey}
  } &> /dev/null
done
