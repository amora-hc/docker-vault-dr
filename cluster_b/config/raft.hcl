ui                = true
disable_mlock     = true
default_lease_ttl = "24h"
max_lease_ttl     = "168h"

api_addr          = "http://docker-vault-dr_cluster_b:8220"
cluster_addr      = "http://docker-vault-dr_cluster_b:8221"

storage "raft" {
  path = "/vault/file"
}

listener "tcp" {
  address         = "0.0.0.0:8220"
  cluster_address = "0.0.0.0:8221"
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
