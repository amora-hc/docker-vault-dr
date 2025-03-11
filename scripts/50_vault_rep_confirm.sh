#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo "Enabling kv secrets engine on PRIMARY (cluster_a)"
sleep 3
set -xe
vault secrets enable -path=replicated-secrets -version=2 kv
{ set +x; } 2>/dev/null
set +e
echo
echo "Creating kv secret on PRIMARY (cluster_a)"
echo
sleep 1
set -xe
vault kv put replicated-secrets/key-failover failover=false status=primary secret=password123
{ set +x; } 2>/dev/null
set +e
echo
echo "Checking replication status on PRIMARY (cluster_a)"
echo
sleep 2
set -xe
vault read sys/replication/dr/status
{ set +x; } 2>/dev/null
set +e
echo

export VAULT_ADDR=http://127.0.0.1:8220

echo "Checking replication status on SECONDARY (cluster_b)"
echo
sleep 2
set -xe
vault read sys/replication/dr/status