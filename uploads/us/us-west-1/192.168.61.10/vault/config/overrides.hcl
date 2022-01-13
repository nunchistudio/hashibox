api_addr     = "http://192.168.61.10:8200"
cluster_addr = "https://192.168.61.10:8201"

listener "tcp" {
  address     = "192.168.61.10:8200"
  tls_disable = true
}

service_registration "consul" {
  address = "192.168.60.10:8500"
}
