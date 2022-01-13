#!/bin/bash

# Install required and useful packages.
echo "==> Installing `apt` packages..."
sudo apt-get install -y \
  curl \
  unzip \
  vim \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common
