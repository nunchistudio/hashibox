#!/bin/bash

# Read the content of the environment file, which is populated with the
# `VAULT_LICENSE`. If a license key is present, Vault Enterprise will be
# downloaded instead of Vault OSS.
source /hashibox/.env

# Set Vault version.
VAULT_VERSION="1.12.2"
if [[ ! -z ${VAULT_LICENSE} ]]; then
  VAULT_VERSION+="+ent"
fi

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Download and unzip Vault.
curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/vault.zip
sudo unzip /tmp/vault.zip -d /tmp/

# Stop the current Vault agent.
sudo systemctl stop vault

# Install Vault and remove temporary archive.
sudo install /tmp/vault /usr/local/bin/vault
sudo rm /tmp/vault /tmp/vault.zip

# Enable autocompletion on Vault CLI.
vault -autocomplete-install
complete -C /usr/local/bin/vault vault

# Add the updated Vault systemd service.
sudo cp /hashibox/defaults/vault/vault.service /etc/systemd/system/vault.service

# If we made it here, we're done!
sudo systemctl start vault
