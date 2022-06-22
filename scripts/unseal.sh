#!/bin/bash
set -euo pipefail

unseal_key="$1"
vault_addresses=(192.168.60.10 192.168.60.20 192.168.60.30)

for ip in "${vault_addresses[@]}"; do
  curl --header "Content-Type: application/json" \
    --request POST \
    --data "{\"key\":\"${unseal_key}\"}" \
    http://"$ip":8200/v1/sys/unseal
done
