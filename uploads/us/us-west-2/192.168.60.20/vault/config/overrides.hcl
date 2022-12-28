api_addr     = "http://192.168.60.20:8200"
cluster_addr = "http://192.168.60.20:8201"

storage "raft" {
  path    = "/opt/vault"
  node_id = "us-west-2"
}

service_registration "consul" {
  address = "192.168.61.20:8500"
}

listener "tcp" {
  tls_disable     = true
  address         = "192.168.60.20:8200"
  cluster_address = "192.168.60.20:8201"

  telemetry {
    unauthenticated_metrics_access = true
  }
}
