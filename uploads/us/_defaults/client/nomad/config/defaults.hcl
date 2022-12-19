data_dir = "/opt/nomad"

server {
  enabled = false
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

  host_volume "waypoint" {
    path      = "/opt/waypoint"
    read_only = false
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

    volumes {
      enabled = true
    }
  }
}

consul {
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

acl {
  enabled = false
}
