#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo "Enabling cluster replication on PRIMARY (cluster_a)"
sleep 3
vault write -f sys/replication/dr/primary/enable
echo "Cluster replication enabled on PRIMARY (cluster_a)"
echo 
echo "Requesting a DR secondary activation token on PRIMARY (cluster_a)"
sleep 3
vault write -field wrapping_token sys/replication/dr/primary/secondary-token id=cluster_b > ./secondary_token

