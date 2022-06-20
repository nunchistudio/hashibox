.PHONY: up halt restart destroy init sync update ssh

export VAGRANT_EXPERIMENTAL="dependency_provisioners"
VAULT_UNSEAL_KEY ?= "INSERT-VAULT-UNSEAL-KEY"
UBUNTU_VERSION ?= "20.04"
VAGRANT_PROVIDER ?= "virtualbox"

#
# up is a shortcut to start the Vagrant environment.
#
up:
	UBUNTU_VERSION=${UBUNTU_VERSION} vagrant up --provider=${VAGRANT_PROVIDER}

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt
	UBUNTU_VERSION=${UBUNTU_VERSION} vagrant up --provider=${VAGRANT_PROVIDER}

#
# destroy is a shortcut to stop and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f

#
# init is a shortcut to initialize the `hashibox` environment for the first time.
#
init:
	UBUNTU_VERSION=${UBUNTU_VERSION} vagrant up --provider=${VAGRANT_PROVIDER} --no-provision
	./scripts/upload.sh
	./scripts/install.sh

#
# sync is a shortcut to synchronize the local `upload` directory with the
# appropriate targeted nodes. It also applies some environment variables and
# then restarts the Consul, Nomad, and Vault services.
#
sync:
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/restart.sh

#
# update is a shortcut to update Consul, Nomad, Vault, and Docker on every nodes.
#
update:
	./scripts/update.sh

#
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root

#
# unseal is a shortcut to unseal the Vault servers given a single unseal key VAULT_UNSEAL_KEY
#
unseal:
	./scripts/unseal.sh $(VAULT_UNSEAL_KEY)
