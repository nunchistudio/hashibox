plan client::install (TargetSpec $targets) {

  # Update packages and install a few requirements.
  run_task('client::refresh', $targets)
  run_task('client::prepare', $targets)

  # Download and install Docker, Consul, and Nomad.
  run_task('docker::install', $targets)
  run_task('consul::install', $targets)
  run_task('nomad::install', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('client::reload', $targets)

  # So far so good.
  return run_command('echo "==> Installation successfully completed!"', $targets)
}
