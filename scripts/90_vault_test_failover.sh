#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8220
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo
echo "Checking data replication from SECONDARY (cluster_b)"
vault kv get replicated-secrets/key-failover
echo
echo "Updating kv secret on new PRIMARY (cluster_b)"
echo
sleep 1
vault kv put replicated-secrets/key-failover failover=true status=failover secret=passwordABC
