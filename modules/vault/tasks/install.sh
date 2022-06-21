#!/bin/bash

# Set Vault version.
VAULT_VERSION="1.10.3"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Download and unzip Vault.
echo "==> Downloading Vault v${VAULT_VERSION}..."
curl -sSL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/vault.zip
sudo unzip /tmp/vault.zip -d /tmp/

# Install Vault and remove temporary archive.
echo "==> Installing Vault v${VAULT_VERSION}..."
sudo install /tmp/vault /usr/local/bin/vault
sudo rm /tmp/vault /tmp/vault.zip

# Enable autocompletion on Vault CLI.
vault -autocomplete-install
complete -C /usr/local/bin/vault vault

# Create a unique, non-privileged system user to run Vault and create its data
# directory.
sudo useradd --system --shell /bin/false vault
sudo mkdir --parents /opt/vault
sudo chown --recursive vault:vault /opt/vault

# Add the appropriate Vault systemd service.
sudo cp /hashibox/defaults/vault/vault.service /etc/systemd/system/vault.service

# If we made it here, we're done!
echo "==> Successfully installed Vault"
