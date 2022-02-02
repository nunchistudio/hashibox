#!/bin/bash

# Make sure a `hashibox` directory exists. It's not the case when initializing
# the Vagrant environment for the first time. If this directory doesn't exist
# then all uploads and services will fail since it relies on it.
bolt command run "mkdir -p /hashibox" --targets=us --run-as root

# Make sure to start with empty `defaults` and `overrides` directories so there
# is no conflict when uploading files. We don't simply remove the `hashibox`
# directory since it contains the `.env` file containing environment variables
# written when starting the Vagrant box.
bolt command run "rm -rf /hashibox/defaults /hashibox/overrides" --targets=us --run-as root

# Upload default configuration files for agents acting as servers. Also, upload
# specific configuration file per node to override default behavior.
bolt file upload ./uploads/us/_defaults/server /hashibox/defaults --targets=servers --run-as root
bolt file upload ./uploads/us/us-west-1/192.168.60.10 /hashibox/overrides --targets=192.168.60.10 --run-as root
bolt file upload ./uploads/us/us-west-2/192.168.60.20 /hashibox/overrides --targets=192.168.60.20 --run-as root
bolt file upload ./uploads/us/us-east-1/192.168.60.30 /hashibox/overrides --targets=192.168.60.30 --run-as root

# Upload default configuration files for agents acting as clients. Also, upload
# specific configuration file per node to override default behavior.
bolt file upload ./uploads/us/_defaults/client /hashibox/defaults --targets=clients --run-as root
bolt file upload ./uploads/us/us-west-1/192.168.61.10 /hashibox/overrides --targets=192.168.61.10 --run-as root
bolt file upload ./uploads/us/us-west-2/192.168.61.20 /hashibox/overrides --targets=192.168.61.20 --run-as root
bolt file upload ./uploads/us/us-east-1/192.168.61.30 /hashibox/overrides --targets=192.168.61.30 --run-as root
