ui                = true
disable_mlock     = true
default_lease_ttl = "24h"
max_lease_ttl     = "168h"

api_addr     = "http://docker-vault-dr_cluster_a:8200"
cluster_addr = "http://docker-vault-dr_cluster_a:8201"

storage "raft" {
  path = "/vault/file"
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable     = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  disable_hostname = true
  prometheus_retention_time = "12h"
}

reporting {
  license {
    enabled = false
  }
}
