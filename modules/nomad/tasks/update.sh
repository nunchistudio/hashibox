#!/bin/bash

# Read the content of the environment file, which is populated with the
# `NOMAD_LICENSE`. If a license key is present, Nomad Enterprise will be
# downloaded instead of Nomad OSS.
source /hashibox/.env

# Set Nomad version.
CNI_PLUGINS_VERSION="1.0.1"
NOMAD_VERSION="1.4.3"
if [[ ! -z ${NOMAD_LICENSE} ]]; then
  NOMAD_VERSION+="+ent"
fi

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Download and unzip Nomad.
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_${OS_KIND}_${OS_ARCH}.zip > /tmp/nomad.zip
sudo unzip /tmp/nomad.zip -d /tmp/

# Download CNI plugins so we can use them inside Nomad jobs.
curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-${OS_KIND}-${OS_ARCH}-v${CNI_PLUGINS_VERSION}.tgz > /tmp/cni-plugins.tgz

# Stop the current Nomad agent.
sudo systemctl stop nomad

# Install Nomad and remove temporary archive.
sudo install /tmp/nomad /usr/local/bin/nomad
sudo rm /tmp/nomad /tmp/nomad.zip

# Unzip and install the CNI plugins.
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz
sudo rm /tmp/cni-plugins.tgz

# Add the updated Nomad systemd service.
sudo cp /hashibox/defaults/nomad/nomad.service /etc/systemd/system/nomad.service

# If we made it here, we're done!
sudo systemctl start nomad
