---
title: Maintenance
---

# Maintenance

The setup comes with a `Makefile` to make things easier.

## Start the environment

To start the Vagrant environment, run:
```bash
$ UBUNTU_VERSION=<version> VAULT_TOKEN=<token> make up
```

This assumes your environment has already been initialized. Otherwise, an error
will be prompted.

## Restart the environment

To synchronize the config files as well as the environment variables, and then
restart the Consul, Nomad, and Vault services,  run:
```bash
$ UBUNTU_VERSION=<version> VAULT_TOKEN=<token> make sync
```

To completely restart the Vagrant environment, run:
```bash
$ UBUNTU_VERSION=<version> VAULT_TOKEN=<token> make restart
```

## Stop the environment

To stop the Vagrant environment, run:
```bash
$ make halt
```

## Notes about SSH keys

If you need your machines to connect to private Git repos, you will most likely
need to sync SSH keys from your local machine to your boxes.

First, you must ensure that the Nomad user's known hosts file is populated with
GitHub and Bitbucket hosts, [as described here](https://www.nomadproject.io/docs/job-specification/artifact#download-using-git).

We provide a shortcut for that:
```bash
$ make ssh
```

Then you will need to upload your SSH key:
```bash
$ bolt file upload <path_to_key>/id_rsa /home/vagrant/.ssh/id_rsa --targets=us --run-as root
$ bolt file upload <path_to_key>/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub --targets=us --run-as root
$ bolt command run "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys" --targets=us --run-as root
```
