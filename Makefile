.PHONY: up halt restart destroy init sync update unseal ssh

export VAGRANT_PROVIDER ?= "virtualbox"
export UBUNTU_VERSION ?= 20.04

export VAGRANT_CLIENT_RAM ?= 1024
export VAGRANT_CLIENT_CPUS ?= 1
export VAGRANT_SERVER_RAM ?= 512
export VAGRANT_SERVER_CPUS ?= 1

export VAULT_UNSEAL_KEY ?= "INSERT-VAULT-UNSEAL-KEY"

include .env

#
# init is a shortcut to initialize the HashiBox environment for the first time.
#
init:
	vagrant up --provider=${VAGRANT_PROVIDER}
	./scripts/upload.sh
	./scripts/install.sh

#
# up is a shortcut to start the Vagrant environment. It also applies some
# environment variables, then restarts the Consul, Nomad, and Vault services and
# finally unseal Vault on every server nodes.
#
up:
	vagrant up --provider=${VAGRANT_PROVIDER}
	./scripts/dotenv.sh
	./scripts/restart.sh
	sleep 5
	./scripts/unseal.sh

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt up

#
# destroy is a shortcut to stop and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f

#
# sync is a shortcut to synchronize the local `uploads` directory with the
# appropriate targeted nodes. It also applies some environment variables, then
# restarts the Consul, Nomad, and Vault services and finally unseal Vault on
# every server nodes.
#
sync:
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/restart.sh
	sleep 5
	./scripts/unseal.sh

#
# update is a shortcut to update Consul, Nomad, Vault, and Docker on every nodes.
# It also unseal Vault on every server nodes.
#
update:
	./scripts/update.sh
	sleep 5
	./scripts/unseal.sh

#
# unseal is a shortcut to unseal the Vault servers given a single unseal key.
#
unseal:
	./scripts/unseal.sh

#
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root

