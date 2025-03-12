#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export DR_OPERATION_TOKEN="$(cat ./operation_token)"

echo "Promote SECONDARY to PRIMARY (cluster_a)"
sleep 2
set -xe
vault write -f sys/replication/dr/secondary/promote \
    dr_operation_token=$DR_OPERATION_TOKEN
