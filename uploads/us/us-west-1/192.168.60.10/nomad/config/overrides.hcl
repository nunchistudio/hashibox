datacenter = "us-west-1"

vault {
  enabled = true
  address = "http://192.168.60.10:8200"
}

ui {
  enabled = true

  consul {
    ui_url = "http://192.168.60.10:8500/ui"
  }

  vault {
    ui_url = "http://192.168.60.10:8200/ui"
  }
}
