api_addr     = "http://192.168.60.10:8200"
cluster_addr = "http://192.168.60.10:8201"

storage "raft" {
  path    = "/opt/vault"
  node_id = "us-west-1"
}

service_registration "consul" {
  address = "192.168.61.10:8500"
}

listener "tcp" {
  tls_disable     = true
  address         = "192.168.60.10:8200"
  cluster_address = "192.168.60.10:8201"

  telemetry {
    unauthenticated_metrics_access = true
  }
}
