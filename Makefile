.PHONY: up halt restart destroy init sync update ssh

#
# up is a shortcut to start the Vagrant environment.
#
up:
	vagrant up

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt
	vagrant up

#
# destroy is a shortcut to stop and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f

#
# init is a shortcut to initialize the `hashibox` environment for the first time.
#
init:
	vagrant up --no-provision
	./scripts/sync.sh
	bolt plan run node::install --targets=us

#
# sync is a shortcut to synchronize the local `upload` directory with the
# appropriate targeted nodes.
#
sync:
	./scripts/sync.sh
	bolt command run "systemctl start consul vault nomad" --targets=us --run-as root


#
# update is a shortcut to update every nodes on every datacenters. We go datacenter
# by datacenter so at least 2 nodes acting as servers are always up and running.
#
# Reminder: The notion of "datacenter" is not the same between Consul and Nomad.
# https://nomadproject.io/docs/faq/#q-is-nomad-s-datacenter-parameter-the-same-as-consul-s
#
update:
	bolt plan run node::update --targets=us-west-1
	bolt plan run node::update --targets=us-west-2
	bolt plan run node::update --targets=us-east-1

#
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
