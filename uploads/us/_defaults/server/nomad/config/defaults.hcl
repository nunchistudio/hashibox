data_dir = "/opt/nomad"

region = "us"

bind_addr = "{{ GetInterfaceIP \"eth1\" }}"

server {
  enabled          = true
  bootstrap_expect = 3

  server_join {
    retry_join = [
      "192.168.60.10",
      "192.168.60.20",
      "192.168.60.30"
    ]
  }
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

client {
  enabled = false
}

telemetry {
  collection_interval        = "1s"
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

consul {
  address             = "{{ GetInterfaceIP \"eth1\" }}:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

acl {
  enabled = true

  token_ttl  = "30s"
  policy_ttl = "60s"
  role_ttl   = "60s"
}
