#!/bin/bash

# Make sure to include required environment variables.
source .env

# Bootstrap Consul ACLs, and save the bootstrap token in environment variables.
bootstrap=$(CONSUL_HTTP_ADDR=http://192.168.60.10:8500 consul acl bootstrap --format=json)
token=$(jq -r .SecretID <<< "${bootstrap}")
echo "export CONSUL_HTTP_TOKEN=${token}" | tee -a ./.env &> /dev/null

# Apply the token to Consul agents. It will be used for internal communication
# instead of the anonymous one.
sed -i "" "s/    default = \"<TO_OVERRIDE>\"/    default = \"${token}\"/" \
  ./uploads/us/_defaults/server/consul/config/defaults.hcl

sed -i "" "s/    default = \"<TO_OVERRIDE>\"/    default = \"${token}\"/" \
  ./uploads/us/_defaults/client/consul/config/defaults.hcl
