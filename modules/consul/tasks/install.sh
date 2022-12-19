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
sudo mkdir -p /opt/consul
sudo chown -R consul:consul /opt/consul

# Forward default DNS port 53 to Consul 8600.
iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

# Add the appropriate Consul systemd service.
sudo cp /hashibox/defaults/consul/consul.service /etc/systemd/system/consul.service

# If we made it here, we're done!
echo "==> Successfully installed Consul"
