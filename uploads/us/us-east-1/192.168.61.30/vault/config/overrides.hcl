api_addr     = "http://192.168.61.30:8200"
cluster_addr = "https://192.168.61.30:8201"

listener "tcp" {
  address     = "192.168.61.30:8200"
  tls_disable = true
}

service_registration "consul" {
  address = "192.168.60.30:8500"
}
