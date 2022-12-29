.PHONY: init up halt restart destroy sync update ssh

export VAGRANT_PROVIDER ?= "virtualbox"
export UBUNTU_VERSION ?= 20.04

export VAGRANT_CLIENT_RAM ?= 1024
export VAGRANT_CLIENT_CPUS ?= 1
export VAGRANT_SERVER_RAM ?= 512
export VAGRANT_SERVER_CPUS ?= 1

export VAULT_UNSEAL_KEY ?= "INSERT-VAULT-UNSEAL-KEY"

-include .env

#
# init is a shortcut to initialize the HashiBox environment for the first time.
# Apply the environment variables before installing so we know if we need OSS
# or Enterprise version for Consul, Nomad, and Vault. We need to apply them after
# installation as well since `.env` is now populated with Vault unseal key and
# root token. We then can unseal Vault, bootstrap ACLs on Consul and Nomad, and
# finally sync files with the result of the bootstrap process. Last step is to
# create the Consul and Nomad secret engines on Vault. We wait 45 seconds before
# doing this step to ensure a Vault node is "active".
#
init:
	vagrant up --provider=${VAGRANT_PROVIDER} --parallel
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/init/install.sh
	./scripts/init/vault-init.sh
	./scripts/dotenv.sh
	./scripts/restart.sh
	sleep 5
	./scripts/unseal.sh
	./scripts/init/consul-bootstrap.sh
	./scripts/init/nomad-bootstrap.sh
	make sync
	sleep 45
	./scripts/init/vault-engines.sh

#
# up is a shortcut to start the Vagrant environment. If you made some changes in
# `.env` or configuration file, you'll need to execute `make sync` after.
#
up:
	vagrant up --provider=${VAGRANT_PROVIDER} --parallel

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
	vagrant destroy -f --parallel

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
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
