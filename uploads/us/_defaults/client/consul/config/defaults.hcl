data_dir = "/opt/consul"

datacenter = "us"

ui_config {
  enabled = true
}

enable_local_script_checks = true

server = false

ports {
  http = 8500
  grpc = 8502
  dns  = 8600
}

retry_join = [
  "192.168.60.10",
  "192.168.60.20",
  "192.168.60.30"
]

service {
  name = "consul-client"
}

acl {
  enabled        = true
  default_policy = "deny"
  down_policy    = "deny"

  enable_token_persistence = true

  tokens {
    default = "<CONSUL_HTTP_TOKEN_TO_OVERRIDE>"
  }
}

connect {
  enabled = true
}
