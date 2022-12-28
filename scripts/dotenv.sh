#!/bin/bash

# Make sure to include required environment variables.
source .env

# List all environment variables that can be populated in `/hashibox/.env` inside
# each machine. This file is used as `EnvironmentFile` by each service.
ENV_VARS=(
  CONSUL_HTTP_TOKEN
  NOMAD_TOKEN
  VAULT_TOKEN
  CONSUL_LICENSE
  NOMAD_LICENSE
  VAULT_LICENSE
)

# Create a new `/hashibox/.env` file with no entry.
bolt command run "rm -f /hashibox/.env && touch /hashibox/.env" --targets=us --run-as root

# For each environment variable, if a value is defined locally, add it to the
# environment file on each node.
for ENV_VAR in "${ENV_VARS[@]}"; do
  if [[ ! -z ${!ENV_VAR} ]]; then
    bolt command run "echo $ENV_VAR=${!ENV_VAR} | tee -a /hashibox/.env" --targets=us --run-as root
  fi
done
