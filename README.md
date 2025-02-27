# docker-vault-dr

## Description
This repository contains a docker compose stack with the two single node Vault clusters using raft backend and all the required scripts for deploying a real DR scenario with failover and failback processes.

## Pre-requisites
Install `taskfile` with the following command:
```shell
  brew install go-task
```

Clone git repository:
```shell
git clone https://github.com/amora-hc/docker-vault-dr.git
```

Create `a.env` and `b.env` files in the root folder based on the `*.env.example` files with the following content:

a.env
```shell
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_LICENSE=INSERT_LICENSE_HERE
```
b.env
```shell
export VAULT_ADDR=http://127.0.0.1:8220
export VAULT_LICENSE=INSERT_LICENSE_HERE
```

## Usage
[Taskfile.yml](Taskfile.yml) contains automation commands to manage the DR scenario.

0. Launch vault clusters, initialise and unseal
```shell
task all
```

1. Enable initial replication setup
```shell
task setup
```

2. Trigger failover process
```shell
task failover
```

3. Trigger failback process
```shell
task failback
```