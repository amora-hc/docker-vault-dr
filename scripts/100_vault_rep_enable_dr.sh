#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"
export DR_OPERATION_TOKEN="$(cat ./operation_token)"

echo "Generate public key on SECONDARY (cluster_a)"
export DR_SECONDARY_PUB_KEY=$(vault write -field secondary_public_key -f sys/replication/dr/secondary/generate-public-key)

export VAULT_ADDR=http://127.0.0.1:8220

echo
echo "Requesting a DR secondary activation token on new PRIMARY (cluster_b)"
export CLUSTER_A_DR_SECONDARY_TOKEN="$(vault write -field token \
 sys/replication/dr/primary/secondary-token id=cluster_a secondary_public_key=$DR_SECONDARY_PUB_KEY)"

export VAULT_ADDR=http://127.0.0.1:8200

echo
echo "Point replication from new PRIMARY to new SECONDARY (cluster_a)"
vault write sys/replication/dr/secondary/update-primary \
    dr_operation_token=$DR_OPERATION_TOKEN token=$CLUSTER_A_DR_SECONDARY_TOKEN
echo
echo "Check replication status on SECONDARY (cluster_a)"
sleep 5
echo
set -xe
vault read --format=json sys/replication/status
{ set +x; } 2>/dev/null
set +e

export VAULT_ADDR=http://127.0.0.1:8220

echo
echo "Checking data replication on PRIMARY (cluster_b)"
echo
set -xe
vault kv get replicated-secrets/key-failover
