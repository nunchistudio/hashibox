data_dir = "/opt/consul"

datacenter = "us"

ui_config {
  enabled = true
}

bootstrap_expect           = 3
enable_local_script_checks = true

server = true

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

acl {
  enabled        = true
  default_policy = "deny"
  down_policy    = "deny"

  enable_token_persistence = true

  tokens {
    default = "<CONSUL_TOKEN_TO_OVERRIDE>"
  }
}

connect {
  enabled = true
}
