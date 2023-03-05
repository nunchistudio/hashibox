#!/bin/bash

# Make sure to include required environment variables.
source .env

# List all members of the Vault cluster so we can then define an active node.
allMembers=$(VAULT_TOKEN=${VAULT_TOKEN} VAULT_ADDR=http://192.168.60.10:8200 vault operator members --format=json)
activeNode=$(jq -r '[.Nodes[] | select(.active_node == true).api_address][0]' <<< "${allMembers}")

# Enable and configure the Consul secret engine using the active node address.
{
  VAULT_TOKEN=${VAULT_TOKEN} VAULT_ADDR=${activeNode} vault secrets enable consul
  VAULT_TOKEN=${VAULT_TOKEN} VAULT_ADDR=${activeNode} vault write consul/config/access \
    address=192.168.60.10:8500 \
    token=${CONSUL_HTTP_TOKEN}
} &> /dev/null

# Enable and configure the Nomad secret engine using the active node address.
{
  VAULT_TOKEN=${VAULT_TOKEN} VAULT_ADDR=${activeNode} vault secrets enable nomad
  VAULT_TOKEN=${VAULT_TOKEN} VAULT_ADDR=${activeNode} vault write nomad/config/access \
    address=http://192.168.60.10:4646 \
    token=${NOMAD_TOKEN}
} &> /dev/null
