storage "raft" {
  path    = "/opt/vault"
  node_id = "us-west-2"
}

service_registration "consul" {
  address = "192.168.61.20:8500"
}
