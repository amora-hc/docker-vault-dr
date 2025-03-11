#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8220
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo
echo "Checking data replication from SECONDARY (cluster_b)"
set -xe
vault kv get replicated-secrets/key-failover
{ set +x; } 2>/dev/null
set +e
echo
echo "Updating kv secret on new PRIMARY (cluster_b)"
echo
sleep 1
set -xe
vault kv put replicated-secrets/key-failover failover=true status=failover secret=passwordABC
