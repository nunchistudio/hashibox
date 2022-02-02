plan server::update (TargetSpec $targets) {

  # Update packages.
  run_task('server::refresh', $targets)

  # Download and update Consul, Nomad, and Vault.
  run_task('consul::update', $targets)
  run_task('nomad::update', $targets)
  run_task('vault::update', $targets)

  # Restart `systemctl` so we can start the agents.
  run_task('server::reload', $targets)

  # So far so good.
  return run_command('echo "==> Update successfully completed!"', $targets)
}
