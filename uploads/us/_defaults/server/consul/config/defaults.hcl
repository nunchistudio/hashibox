data_dir = "/opt/consul"

datacenter = "us"

ui_config {
  enabled = true
}

bootstrap_expect           = 3
enable_local_script_checks = true

server = true

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
    default = "<TO_OVERRIDE>"
  }
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
