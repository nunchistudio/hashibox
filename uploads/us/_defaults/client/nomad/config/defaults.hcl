data_dir = "/opt/nomad"

region = "us"

bind_addr = "{{ GetInterfaceIP \"eth1\" }}"

server {
  enabled = false
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

client {
  enabled = true

  network_interface = "eth1"

  server_join {
    retry_join = [
      "192.168.60.10",
      "192.168.60.20",
      "192.168.60.30"
    ]
  }
}

telemetry {
  collection_interval        = "1s"
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {
    allow_privileged = true

    extra_labels = [
      "job_id", "job_name",
      "node_id", "node_name",
      "namespace",
      "task_group_name", "task_name",
    ]

    volumes {
      enabled = true
    }
  }
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
