---
location: "/documentation/overview.md"
title: "Overview"
---

# {% $markdoc.frontmatter.title %}

HashiBox is a local environment to simulate a highly-available cloud with
[Consul](https://www.consul.io/), [Nomad](https://www.nomadproject.io/), and
[Vault](https://www.vaultproject.io/). OSS and Enterprise versions of each
product are supported.

[Waypoint](https://www.waypointproject.io/) can be added but is optional. It also
installs [Docker](https://www.docker.com/) for running Nomad's jobs inside
containers.

It leverages [Vagrant](https://www.vagrantup.com/) for virtualization, and
[Bolt](https://puppet.com/docs/bolt/) for maintenance automation across nodes.

The main goal of HashiBox is to provide a local setup respecting environment
parity for simulating a Cloud Platform from end-to-end before going in production.

## Infrastructure

This repository simulates a region called `us` in which there are 3 datacenters:
- `us-west-1` with IP address 192.168.x.10.
- `us-west-2` with IP address 192.168.x.20.
- `us-east-1` with IP address 192.168.x.30.

In each datacenter we install 2 nodes:
- One acting as a *server* for Consul, Nomad, and Vault with IP address
  192.168.60.x.
- One acting as a *client* for Consul and Nomad with IP address 192.168.61.x.
  Docker is also installed for running Nomad jobs inside containers.

Here is a summary schema to better understand how this works:

![HashiBox](/images/hashibox-{theme}.png)

## Cloning the repository

You can clone the repository with:

```bash
$ git clone https://github.com/nunchistudio/hashibox
```

## Directory structure

Before continuing and installing the setup, it's important to take a look at the
directory structure to better understand how it works:

- `Vagrantfile`: This is the file to setup the required nodes using Vagrant.
  This also takes care of exposing the private network for each node with the IP
  addresses given earlier.
- `Makefile`: This file allows to populate environment variables and automate
  every tasks within the environment.
- `bolt.yaml`: Required file to leverage the Bolt command-line within this
  directory.
- `inventory.yaml`: This file is used by Bolt and allows us to organize our nodes
  per groups so we can then run tasks on different groups of nodes such as every
  nodes acting as `clients`, or every nodes in the `us-west-1` datacenter.
- `scripts/`: This contains the automation scripts used in the `Makefile`, executed
  on your local machine.
- `modules/`: This contains Bolt tasks and plans to execute on the remote nodes.
- `uploads/`: This directory contains the files uploaded on each node, in each
  datacenter, for each region.
  - `us/`: Applied for the `us` region.
    - `_defaults/`: This directory contains the default configuration files that
      will be applied to all nodes present in the `us` region.
    - `<datacenter>/`: Each directory contains the specific configuration files
      of the datacenter.
