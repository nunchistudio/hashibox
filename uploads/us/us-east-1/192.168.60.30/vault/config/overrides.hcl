api_addr     = "http://192.168.60.30:8200"
cluster_addr = "https://192.168.60.30:8201"

listener "tcp" {
  address         = "192.168.60.30:8200"
  cluster_address = "192.168.60.30:8201"
  tls_disable     = true
}

storage "consul" {
  address = "192.168.60.30:8500"
}
