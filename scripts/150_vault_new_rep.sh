#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"
export DR_OPERATION_TOKEN="$(cat ./operation_token)"

echo "Requesting a new DR secondary activation token on PRIMARY (cluster_a)"
sleep 2
export CLUSTER_B_DR_SECONDARY_TOKEN="$(vault write -field wrapping_token \
   sys/replication/dr/primary/secondary-token id=cluster_b)"

export VAULT_ADDR=http://127.0.0.1:8220
echo
echo "Point replication from initial PRIMARY to initial SECONDARY (cluster_b)"
vault write sys/replication/dr/secondary/update-primary \
   dr_operation_token=$DR_OPERATION_TOKEN token=$CLUSTER_B_DR_SECONDARY_TOKEN

echo "Check replication status on SECONDARY (cluster_b)"
sleep 5
echo
set -xe
vault read sys/replication/dr/status
