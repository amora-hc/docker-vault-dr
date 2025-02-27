#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8220
export DR_OPERATION_TOKEN="$(cat ./operation_token)"

echo "Promote cluster_b to PRIMARY"
sleep 2
vault write -f sys/replication/dr/secondary/promote \
    dr_operation_token=$DR_OPERATION_TOKEN
