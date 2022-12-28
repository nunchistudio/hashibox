#!/bin/bash

# Restart Consul, Nomad, and Vault services on server and client nodes. Restart
# Docker on client nodes.
bolt command run "systemctl restart consul nomad vault" --targets=servers --run-as root &
  bolt command run "systemctl restart consul nomad" --targets=clients --run-as root &
  bolt command run "service docker restart" --targets=clients --run-as root &
  wait
