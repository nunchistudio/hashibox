---
location: "/documentation/maintenance.md"
title: "Maintenance cheatsheet"
---

# {% $markdoc.frontmatter.title %}

This is a cheatsheet. Please refer to the documentation for step-by-step guides.

The setup and maintenance are orchestrated via a `Makefile`. It shall be used
for as much tasks as possible since it automates scripts and environment
variables.

## Environment variables

Environment variables can be exported via a `.env` file at the top-level directory
of HashiBox.

Once HashiBox has been initialized, we assume the following required environment
variables are set on your machine:

```bash
export VAULT_UNSEAL_KEY=<key>
export VAULT_TOKEN=<token>
export CONSUL_HTTP_TOKEN=<token>
export NOMAD_TOKEN=<token>
```

Optional environment variables for tweaking Vagrant:

```bash
export UBUNTU_VERSION=20.04-arm64
export VAGRANT_PROVIDER=parallels
export VAGRANT_CLIENT_RAM=2048
export VAGRANT_CLIENT_CPUS=1
export VAGRANT_SERVER_RAM=1024
export VAGRANT_SERVER_CPUS=1
```

Optional environment variables to install HashiCorp Enterprise products using
license keys, used on `make init` and `make update`:

```bash
export CONSUL_LICENSE=<key>
export NOMAD_LICENSE=<key>
export VAULT_LICENSE=<key>
```

## Summary table

{% table %}
* Datacenter
* Agent's mode
* IP address
* Link to Consul
* Link to Nomad
* Link to Vault
---
* `us-west-1`
* *server*
* 192.168.60.10
* [:8500](http://192.168.60.10:8500)
* [:4646](http://192.168.60.10:4646)
* [:8200](http://192.168.60.10:8200)
---
* `us-west-1`
* *client*
* 192.168.61.10
* [:8500](http://192.168.61.10:8500)
* [:4646](http://192.168.61.10:4646)
* *n/a*
---
* `us-west-2`
* *server*
* 192.168.60.20
* [:8500](http://192.168.60.20:8500)
* [:4646](http://192.168.60.20:4646)
* [:8200](http://192.168.60.20:8200)
---
* `us-west-2`
* *client*
* 192.168.61.20
* [:8500](http://192.168.61.20:8500)
* [:4646](http://192.168.61.20:4646)
* *n/a*
---
* `us-east-1`
* *server*
* 192.168.60.30
* [:8500](http://192.168.60.30:8500)
* [:4646](http://192.168.60.30:4646)
* [:8200](http://192.168.60.30:8200)
---
* `us-east-1`
* *client*
* 192.168.61.30
* [:8500](http://192.168.61.30:8500)
* [:4646](http://192.168.61.30:4646)
* *n/a*
{% /table %}

## Makefile shortcuts

### Start the environment

To start the Vagrant environment, run:

```bash
$ make up
```

This assumes your environment has already been initialized. Otherwise, an error
will be prompted.

### Apply changes to the services

The most useful command when working / collaborating on HashiBox is probably this
one:

```bash
$ make sync
```

This:
1. uploads the config files from your local machine to your virtual machines for
   *server* and *client* nodes;
2. updates the environment variables of your virtual machines using the ones from
   the local `.env` file;
3. restarts the Consul, Nomad, and Vault services on every nodes;
4. unseals Vault on *server* nodes.

### Restart the environment

To completely restart the Vagrant environment, run:

```bash
$ make restart
```

### Update the services

To update the services to the latest version, run:

```bash
$ make update
```

### Stop the environment

To stop the Vagrant environment, run:

```bash
$ make halt
```

### Destroy the environment

To stop and destroy the Vagrant environment, run:

```bash
$ make destroy
```

## Notes about SSH keys

If you need your virtual machines to connect to private Git repos, you will most
likely need to sync SSH keys from your local machine to your virtual machines.

First, you must ensure that the Nomad user's known hosts file is [populated with
GitHub and Bitbucket hosts](https://www.nomadproject.io/docs/job-specification/artifact#download-using-git).

We provide a shortcut to achieve this:

```bash
$ make ssh
```

Then you will need to upload your SSH key. This can be done with:

```bash
$ bolt file upload <path_to_key>/id_rsa /home/vagrant/.ssh/id_rsa \
  --targets=us --run-as root

$ bolt file upload <path_to_key>/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub \
  --targets=us --run-as root

$ bolt command run "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys" \
  --targets=us --run-as root
```
