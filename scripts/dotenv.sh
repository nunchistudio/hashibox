#!/bin/bash

# Create a new dotenv file with no entry.
bolt command run "rm /hashibox/.env && touch /hashibox/.env" --targets=us --run-as root

# Add the Consul, Nomad, and Vault tokens from local environment variables.
bolt command run "echo CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
bolt command run "echo NOMAD_TOKEN=$NOMAD_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
bolt command run "echo VAULT_TOKEN=$VAULT_TOKEN | tee -a /hashibox/.env" --targets=us --run-as root
