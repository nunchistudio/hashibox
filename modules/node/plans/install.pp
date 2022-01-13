plan node::install (TargetSpec $targets) {

  # Update packages and install a few requirements.
  run_task('node::refresh', $targets)
  run_task('node::prepare', $targets)

  # Download and install Docker, Consul, Vault, and Nomad.
  run_task('docker::install', $targets)
  run_task('consul::install', $targets)
  run_task('vault::install', $targets)
  run_task('nomad::install', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('node::reload', $targets)

  # So far so good.
  return run_command('echo "==> Installation successfully completed!"', $targets)
}
