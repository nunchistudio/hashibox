region     = "us"
datacenter = "us-west-1"

bind_addr = "192.168.61.10"

consul {
  address = "192.168.61.10:8500"
}

vault {
  enabled = true
  address = "http://192.168.60.10:8200"
}
