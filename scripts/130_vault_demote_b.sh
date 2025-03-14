#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8220
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo "Demote PRIMARY to SECONDARY (cluster_b)"
sleep 2
set -xe
vault write -f sys/replication/dr/primary/demote
