data_dir = "/opt/consul"

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

ports {
  http  = 8500
  // https = 8501
  grpc  = 8502
}

service {
  name = "consul-client"
}
