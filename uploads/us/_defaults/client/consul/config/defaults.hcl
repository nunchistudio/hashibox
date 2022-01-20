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

acl {
  enabled                  = false
  default_policy           = "allow"
  enable_token_persistence = true
}

connect {
  enabled     = true
  // ca_provider = "vault"

  // ca_config {
  //   address = "http://192.168.60.10:8200"
  //   token   = ""

  //   root_pki_path         = "connect-root"
  //   intermediate_pki_path = "connect-intermediate"
  // }
}
