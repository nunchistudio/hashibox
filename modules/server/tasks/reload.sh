#!/bin/bash

# Restart `systemctl` so we can then start the agents.
sudo systemctl daemon-reload
sudo systemctl start consul nomad vault
