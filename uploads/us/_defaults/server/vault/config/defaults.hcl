ui = true

storage "consul" {
  path             = "vault/"
  consistency_mode = "strong"
}

telemetry {
  prometheus_retention_time = "24h"
  disable_hostname          = true
}
