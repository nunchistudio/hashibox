region     = "us"
datacenter = "us-west-2"

bind_addr = "192.168.60.20"

consul {
  address = "192.168.60.20:8500"
}

vault {
  enabled = true
  address = "http://192.168.60.20:8200"
}
