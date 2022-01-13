---
title: Vault initialization
---

# Vault initialization

Once the Vagrant setup is done, you must configure and unseal Vault in order for
Nomad to work as expected.

## Initialize Vault

If you go to <http://192.168.60.10:8200> you will see the Vault UI for the server
node on the `eu-west-1` datacenter. For our demo, let's configure Vault simply
with:
![Vault initialization](../assets/vault-init-01.png)

Copy and paste in your notes the initial root token given as well as the key:
![Vault initialization](../assets/vault-init-02.png)

## Restart the environment

You can now restart the machines with the Vault token given:
```bash
$ VAULT_TOKEN=<token> make restart
```

This will restart every nodes and pass the `VAULT_TOKEN` environment variable
down to the Vagrant boxes. This way, it can be used by Consul and Nomad for
interacting with Vault.

## Unseal Vault

If you access the Consul UI at <http://192.168.60.10:8500>, you will note that
Vault is still not healthy:
![Consul Services](../assets/consul-init-02.png)

It is because you need to unseal Vault on every nodes. To achieve this, access
the Vault UI and unseal Vault on nodes via:
- <http://192.168.60.10:8200> for `eu-west-1`
- <http://192.168.60.20:8200> for `eu-west-2`
- <http://192.168.60.30:8200> for `eu-east-1`

In Consul, we can see that every health checks are now passing and the service list
looks like this:
![Consul Services](../assets/consul-init-03.png)

Since Vault is heathly, Nomad can interact with it via the root token passed with
`VAULT_TOKEN`. Let's take a look at Nomad:
![Nomad Clients](../assets/nomad-clients.png)

Happy hacking!
