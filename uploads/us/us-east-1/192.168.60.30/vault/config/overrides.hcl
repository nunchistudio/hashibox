storage "raft" {
  path    = "/opt/vault"
  node_id = "us-east-1"
}

service_registration "consul" {
  address = "192.168.61.30:8500"
}
