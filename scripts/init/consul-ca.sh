#!/bin/bash

# Make sure to include required environment variables.
source .env

# Create a temporary directory to store Consul CA configuration files for Vault.
mkdir -p ./scripts/init/.assets/consul-ca

# List IP addresses running a Consul server.
IP_SERVERS=(
  192.168.60.10
  192.168.60.20
  192.168.60.30
)

# List IP addresses running a Consul client.
IP_CLIENTS=(
  192.168.61.10
  192.168.61.20
  192.168.61.30
)

# For each Consul client, create a Connect configuration file using Vault as CA
# provider. Then, use the Consul CLI to apply the changes on the Consul client.
for i in "${!IP_CLIENTS[@]}"; do
  {
    touch ./scripts/init/.assets/consul-ca/${IP_CLIENTS[i]}.json
    cat <<EOT >> ./scripts/init/.assets/consul-ca/${IP_CLIENTS[i]}.json
{
  "Provider": "vault",
  "Config": {
    "Address": "http://${IP_SERVERS[i]}:8200",
    "Token": "${VAULT_TOKEN}",
    "RootPKIPath": "pki-connect-root",
    "IntermediatePKIPath": "pki-connect-int"
  }
}
EOT

    CONSUL_HTTP_TOKEN=${CONSUL_HTTP_TOKEN} CONSUL_HTTP_ADDR=http://${IP_CLIENTS[i]}:8500 \
      consul connect ca set-config -config-file ./scripts/init/.assets/consul-ca/${IP_CLIENTS[i]}.json
  } &> /dev/null
done

# Remove the temporary directory.
rm -rf ./scripts/init/.assets
