#!/bin/bash

# Set Nomad version.
NOMAD_VERSION="1.2.6"
CNI_PLUGINS_VERSION="1.0.1"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"

# Download and unzip Nomad.
echo "==> Downloading Nomad v${NOMAD_VERSION}..."
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/nomad.zip
sudo unzip /tmp/nomad.zip -d /tmp/

# Download CNI plugins so we can use them inside Nomad jobs.
curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-${OS_KIND}-${OS_ARCH}-v${CNI_PLUGINS_VERSION}.tgz > /tmp/cni-plugins.tgz

# Install Nomad and remove temporary archive.
echo "==> Installing Nomad v${NOMAD_VERSION}..."
sudo install /tmp/nomad /usr/local/bin/nomad
sudo rm /tmp/nomad /tmp/nomad.zip

# Unzip and install the CNI plugins.
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
sudo rm /tmp/cni-plugins.tgz

# Enable autocompletion on Nomad CLI.
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad

# Create a unique, non-privileged system user to run Nomad and create its data
# directory.
sudo useradd --system --shell /bin/false nomad
sudo mkdir --parents /opt/nomad
sudo chown --recursive nomad:nomad /opt/nomad

# Write a file to preserve network settings.
cat > /etc/sysctl.d/20-bridge << EOF
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Add the appropriate Nomad systemd service.
sudo cp /hashibox/defaults/nomad/nomad.service /etc/systemd/system/nomad.service

# If we made it here, we're done!
echo "==> Successfully installed Nomad"
