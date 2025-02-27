#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo "Enabling kv secrets engine on PRIMARY (cluster_a)"
sleep 3
vault secrets enable -path=replicated-secrets -version=2 kv
echo
echo "Creating kv secret on PRIMARY (cluster_a)"
echo
sleep 1
vault kv put replicated-secrets/key-failover failover=false status=primary secret=password123
echo
echo "Checking replication status on PRIMARY (cluster_a)"
echo
sleep 2
vault read sys/replication/dr/status
echo

export VAULT_ADDR=http://127.0.0.1:8220

echo "Checking replication status on SECONDARY (cluster:b)"
echo
sleep 2
vault read sys/replication/dr/status