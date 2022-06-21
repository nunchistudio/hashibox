#!/bin/bash

# Set Docker version.
DOCKER_VERSION="stable"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="ubuntu"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Install the latest version of Docker Engine - Community and containerd.
echo "==> Installing ${DOCKER_VERSION} version of Docker...."
sudo apt-get install -f -y \
  docker-ce \
  docker-ce-cli \
  containerd.io

# If we made it here, we're done!
echo "==> Successfully updated Docker"
