#!/bin/bash

# Set Docker version.
DOCKER_VERSION="stable"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"

# Remove previous Docker-related packages.
echo "==> Removing old Docker-related packages...."
sudo apt-get remove \
  docker \
  docker-engine \
  docker.io \
  containerd \
  runc

# Add Docker’s official GPG key.
curl -fsSL https://download.docker.com/${OS_KIND}/${OS_DISTRO}/gpg | sudo apt-key add -

# Verify that the key with the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Setup the appropriate Docker repository.
sudo add-apt-repository \
  "deb [arch=${OS_ARCH}] https://download.docker.com/${OS_KIND}/${OS_DISTRO} \
  $(lsb_release -cs) \
  ${DOCKER_VERSION}"

# Install the latest version of Docker Engine - Community and containerd.
echo "==> Installing ${DOCKER_VERSION} version of Docker...."
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io

# Restart Docker to make sure we get the latest version of the daemon if there
# is an upgrade
sudo service docker stop

# Make sure we can actually use Docker as the current user.
sudo usermod -aG docker $USER

# If we made it here, we're done!
echo "==> Successfully installed Docker"
