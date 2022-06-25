---
title: Maintenance
---

# Maintenance

The setup comes with a `Makefile` to make things easier.

We assume the following required environment variables are set on your machine:
```bash
export VAULT_TOKEN=<token>
export VAULT_UNSEAL_KEY=<key>
```

## Start the environment

To start the Vagrant environment, run:
```bash
$ make up
```

This assumes your environment has already been initialized. Otherwise, an error
will be prompted.

## Apply changes to the services

The most useful command when working / collaborating on HashiBox is probably this
one:
```bash
$ make sync
```

This:
1. uploads the config files from your local machine to your virtual machines for
   *server* and *client* nodes;
2. updates the environment variables of your virtual machines using the ones from
   your local machine;
3. restarts the Consul, Nomad, and Vault services on every nodes;
4. unseals Vault on *server* nodes.

## Restart the environment

To completely restart the Vagrant environment, run:
```bash
$ make restart
```

## Update the services

To update the services to the latest version, run:
```bash
$ make update
```

## Stop the environment

To stop the Vagrant environment, run:
```bash
$ make halt
```

## Notes about SSH keys

If you need your virtual machines to connect to private Git repos, you will most
likely need to sync SSH keys from your local machine to your virtual machines.

First, you must ensure that the Nomad user's known hosts file is populated with
GitHub and Bitbucket hosts, [as described here](https://www.nomadproject.io/docs/job-specification/artifact#download-using-git).

We provide a shortcut for that:
```bash
$ make ssh
```

Then you will need to upload your SSH key. This can be done with:
```bash
$ bolt file upload <path_to_key>/id_rsa /home/vagrant/.ssh/id_rsa --targets=us --run-as root
$ bolt file upload <path_to_key>/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub --targets=us --run-as root
$ bolt command run "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys" --targets=us --run-as root
```
