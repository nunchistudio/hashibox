api_addr     = "http://192.168.60.10:8200"
cluster_addr = "http://192.168.60.10:8201"

storage "consul" {
  address = "192.168.60.10:8500"
}

listener "tcp" {
  tls_disable     = true
  address         = "192.168.60.10:8200"
  cluster_address = "192.168.60.10:8201"
}
