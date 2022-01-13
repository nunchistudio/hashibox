#!/bin/bash

# Set Consul version.
CONSUL_VERSION="1.11.1"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"

# Download and unzip Consul.
echo "==> Downloading Consul v${CONSUL_VERSION}..."
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/consul.zip
sudo unzip /tmp/consul.zip -d /tmp/

# Install Consul and remove temporary archive.
echo "==> Installing Consul v${CONSUL_VERSION}..."
sudo install /tmp/consul /usr/local/bin/consul
sudo rm /tmp/consul /tmp/consul.zip

# Enable autocompletion on Consul CLI.
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

# Create a unique, non-privileged system user to run Consul and create its data
# directory.
sudo useradd --system --shell /bin/false consul
sudo mkdir --parents /opt/consul
sudo chown --recursive consul:consul /opt/consul

# Add the appropriate Consul systemd service.
sudo cp /hashibox/defaults/consul/consul.service /etc/systemd/system/consul.service

# If we made it here, we're done!
echo "==> Successfully installed Consul"
