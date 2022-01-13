#!/bin/bash

# Make sure to start with an empty `hashibox` directory.
bolt command run "rm -f /hashibox" --targets=us --run-as root
bolt command run "mkdir /hashibox && touch /hashibox/.env" --targets=us --run-as root

# Upload default configuration files for agents acting as servers. Also,
# upload specific configuration file per node to add / override default
# behavior. Targets: nodes acting as servers in the "us" region.
bolt file upload ./uploads/us/_defaults/server /hashibox/defaults --targets=servers --run-as root
bolt file upload ./uploads/us/us-west-1/192.168.60.10 /hashibox/overrides --targets=192.168.60.10 --run-as root
bolt file upload ./uploads/us/us-west-2/192.168.60.20 /hashibox/overrides --targets=192.168.60.20 --run-as root
bolt file upload ./uploads/us/us-east-1/192.168.60.30 /hashibox/overrides --targets=192.168.60.30 --run-as root

# Upload default configuration files for agents acting as clients. Also,
# upload specific configuration file per node to add / override default
# behavior. Targets: nodes acting as clients in the "us" region.
bolt file upload ./uploads/us/_defaults/client /hashibox/defaults --targets=clients --run-as root
bolt file upload ./uploads/us/us-west-1/192.168.61.10 /hashibox/overrides --targets=192.168.61.10 --run-as root
bolt file upload ./uploads/us/us-west-2/192.168.61.20 /hashibox/overrides --targets=192.168.61.20 --run-as root
bolt file upload ./uploads/us/us-east-1/192.168.61.30 /hashibox/overrides --targets=192.168.61.30 --run-as root
