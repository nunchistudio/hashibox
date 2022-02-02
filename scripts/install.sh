#!/bin/bash

# Run the "install" plan on server and client nodes.
bolt plan run server::install --targets=servers --run-as root
bolt plan run client::install --targets=clients --run-as root
