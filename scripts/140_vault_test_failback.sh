#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

echo "Verify replication status on PRIMARY (cluster_a)"
echo
vault read sys/replication/dr/status

export VAULT_ADDR=http://127.0.0.1:8220

echo
echo "Verify replication status on SECONDARY (cluster_b)"
echo
sleep 5
vault read sys/replication/dr/status

export VAULT_ADDR=http://127.0.0.1:8200

echo
echo "Updating kv secret on initial PRIMARY (cluster_a)"
echo
sleep 1
vault kv put replicated-secrets/key-failover failover=false status=failback secret=passwordXYZ
