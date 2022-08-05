---
location: "/documentation/waypoint.md"
title: "Adding Waypoint"
---

# {% $markdoc.frontmatter.title %}

In some cases, you may want to use [Waypoint](https://www.waypointproject.io/),
allowing developers to deploy, manage, and observe their applications through a
consistent abstraction of underlying infrastructure.

## Prerequisites

To interact with a Waypoint server and runners, you first need to [install Waypoint
on your machine](https://learn.hashicorp.com/tutorials/waypoint/get-started-install).

**TLDR:** For macOS with [Homebrew](https://brew.sh/):

```bash
$ brew install hashicorp/tap/waypoint
```

## Installing Waypoint on Nomad

Since we already have a running Nomad cluster, adding Waypoint to HashiBox is
pretty straightforward.

By running the following command, you install a Waypoint *server* and *runner*
on the Nomad client in the `us-west-1` datacenter, and also register Waypoint
services in Consul:

```bash
$ export NOMAD_ADDR=http://192.168.60.10:4646
$ waypoint install -accept-tos -platform=nomad \
  -nomad-host=192.168.60.10:4646 \
  -nomad-region=us \
  -nomad-dc=us-west-1 \
  -nomad-consul-service=true \
  -nomad-consul-service-hostname=192.168.61.10 \
  -nomad-consul-datacenter=us \
  -nomad-host-volume=waypoint
```

No need to manually create the Nomad host volume `waypoint`. It has already been
created by Nomad clients via the configuration files.

Once done, the Waypoint UI is available at <https://192.168.61.10:9702>.
