data_dir = "/opt/consul"

datacenter = "us"

ui_config {
  enabled = true
}

enable_local_script_checks = true

server = false

retry_join = [
  "192.168.60.10",
  "192.168.60.20",
  "192.168.60.30"
]

service {
  name = "consul-client"
}
