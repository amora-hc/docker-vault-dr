#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8220
export VAULT_TOKEN="$(cat ./cluster_b/init.json | jq -r '.root_token')"
export DR_SECONDARY_TOKEN="$(cat ./secondary_token)"

echo "Enabling cluster replication on SECONDARY (cluster_b)"
sleep 3
set -xe
vault write sys/replication/dr/secondary/enable token=$DR_SECONDARY_TOKEN
{ set +x; } 2>/dev/null
set +e
echo "Cluster replication enabled on SECONDARY (cluster_b)"
