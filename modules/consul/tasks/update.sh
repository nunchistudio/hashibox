#!/bin/bash

# Read the content of the environment file, which is populated with the
# `CONSUL_LICENSE`. If a license key is present, Consul Enterprise will be
# downloaded instead of Consul OSS.
source /hashibox/.env

# Set Consul version.
CONSUL_VERSION="1.14.3"
if [[ ! -z ${CONSUL_LICENSE} ]]; then
  CONSUL_VERSION+="+ent"
fi

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Download and unzip Consul.
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/consul.zip
sudo unzip /tmp/consul.zip -d /tmp/

# Stop the current Consul agent.
sudo systemctl stop consul

# Install Consul and remove temporary archive.
sudo install /tmp/consul /usr/local/bin/consul
sudo rm /tmp/consul /tmp/consul.zip

# Enable autocompletion on Consul CLI.
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

# Add the updated Consul systemd service.
sudo cp /hashibox/defaults/consul/consul.service /etc/systemd/system/consul.service

# If we made it here, we're done!
sudo systemctl start consul
