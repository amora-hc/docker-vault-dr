#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN="$(cat ./cluster_a/init.json | jq -r '.root_token')"

## Take a snapshot

echo "Taking snapshot of PRIMARY data (cluster_a)"
sleep 3
set -x
vault operator raft snapshot save cluster_a/vault-cluster-a-snapshot.snap
{ set +x; } 2>/dev/null
set +e
echo
echo "Confirming snapshot has been created..."
sleep 1
ls -lh cluster_a/vault-cluster-a-snapshot.snap

## Batch disaster recovery operation token strategy

echo
echo "Writing policy for enabling cluster promotion..."
sleep 3
vault policy write dr-secondary-promotion - <<EOF
path "sys/replication/dr/secondary/promote" {
  capabilities = [ "update" ]
}

# To update the primary to connect
path "sys/replication/dr/secondary/update-primary" {
    capabilities = [ "update" ]
}

# Only if using integrated storage (raft) as the storage backend
# To read the current autopilot status
path "sys/storage/raft/autopilot/state" {
    capabilities = [ "update" , "read" ]
}
EOF

echo
echo "Creating failover token role on PRIMARY (cluster_a)"
sleep 3
set -x
vault write auth/token/roles/failover-handler \
    allowed_policies=dr-secondary-promotion \
    orphan=true \
    renewable=false \
    token_type=batch
{ set +x; } 2>/dev/null
set +e

echo
echo "Creating and exporting DR operation token to file"
sleep 3
set -xe
vault token create \
    -field=token -role=failover-handler -ttl=8h > ./operation_token
