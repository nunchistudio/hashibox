storage "raft" {
  path    = "/opt/vault"
  node_id = "us-west-1"
}

service_registration "consul" {
  address = "192.168.61.10:8500"
}
