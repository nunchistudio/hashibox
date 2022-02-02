plan client::update (TargetSpec $targets) {

  # Update packages.
  run_task('client::refresh', $targets)

  # Download and update Docker, Consul, and Nomad.
  run_task('docker::update', $targets)
  run_task('consul::update', $targets)
  run_task('nomad::update', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('client::reload', $targets)

  # So far so good.
  return run_command('echo "==> Update successfully completed!"', $targets)
}
