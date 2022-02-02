#!/bin/bash

# Run the "update" plan on server and client nodes.
bolt plan run server::update --targets=servers --run-as root
bolt plan run client::update --targets=clients --run-as root
