#!/bin/bash

# Create a new `.env` file with no entry.
bolt command run "rm -f /hashibox/.env && touch /hashibox/.env" --targets=us --run-as root

# Add the Consul HTTP token from local environment variable if applicable.
if [[ ! -z ${CONSUL_HTTP_TOKEN} ]]; then
  bolt command run "echo CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
fi

# Add the Nomad token from local environment variable if applicable.
if [[ ! -z ${NOMAD_TOKEN} ]]; then
  bolt command run "echo NOMAD_TOKEN=$NOMAD_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
fi

# Add the Vault token from local environment variable if applicable.
if [[ ! -z ${VAULT_TOKEN} ]]; then
  bolt command run "echo VAULT_TOKEN=$VAULT_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
fi

# Add the Consul Enterprise license key from local environment variable if
# applicable.
if [[ ! -z ${CONSUL_LICENSE} ]]; then
  bolt command run "echo CONSUL_LICENSE=$CONSUL_LICENSE | tee -a /hashibox/.env" --targets=us --run-as root
fi

# Add the Nomad Enterprise license key from local environment variable if
# applicable.
if [[ ! -z ${NOMAD_LICENSE} ]]; then
  bolt command run "echo NOMAD_LICENSE=$NOMAD_LICENSE | tee -a /hashibox/.env" --targets=us --run-as root
fi

# Add the Vault Enterprise license key from local environment variable if
# applicable.
if [[ ! -z ${VAULT_LICENSE} ]]; then
  bolt command run "echo VAULT_LICENSE=$VAULT_LICENSE | tee -a /hashibox/.env" --targets=us --run-as root
fi
