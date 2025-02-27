#!/usr/bin/env bash
export VAULT_ADDR=http://127.0.0.1:8200

echo
echo "Check replication status on SECONDARY (cluster_a)"
echo
vault read --format=json sys/replication/status

export VAULT_ADDR=http://127.0.0.1:8220

echo
echo "Check replication status on PRIMARY (cluster_b)"
echo
vault read --format=json sys/replication/status
