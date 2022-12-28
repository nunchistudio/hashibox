plan server::install (TargetSpec $targets) {

  # Update packages and install a few requirements.
  run_task('server::refresh', $targets)
  run_task('server::prepare', $targets)

  # Download and update Consul, Nomad, and Vault.
  run_task('consul::install', $targets)
  run_task('nomad::install', $targets)
  run_task('vault::install', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('server::reload', $targets)
}
