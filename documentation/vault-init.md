---
location: "/documentation/vault-init.md"
title: "Vault initialization"
---

# {% $markdoc.frontmatter.title %}

Once the Vagrant setup is done, you must initialize (and unseal Vault *servers*)
in order for Nomad to work as expected.

## Initialize Vault

If you go to <http://192.168.60.10:8200> you will see the Vault UI for the server
node on the `eu-west-1` datacenter. Let's configure Vault with `1` Key shares and
`1` Key threshold:
![Vault initialization](/screenshots/vault-init-01.png)

Copy the initial root token given as well as the key:
![Vault initialization](/screenshots/vault-init-02.png)

Paste them in `.env`:

```bash
export VAULT_TOKEN=<token>
export VAULT_UNSEAL_KEY=<key>
```

## Apply Vault token and key

You can now restart the Consul, Nomad, and Vault services with the Vault token
and unseal key:

```bash
$ make sync
```

Running `make sync`:
1. uploads the config files from your local machine to your virtual machines for
   *server* and *client* nodes;
2. updates the environment variables of your virtual machines using the ones from
   your local machine;
3. restarts the Consul, Nomad, and Vault services on every nodes;
4. unseals Vault on *server* nodes.

In Consul, we can see that every health checks are now passing and the service list
looks like this:
![Consul Services](/screenshots/consul-services-01.png)

Since Vault is heathly, Nomad can interact with it via the root token passed with
`VAULT_TOKEN`. Let's take a look at Nomad:
![Nomad Clients](/screenshots/nomad-clients-01.png)

**Happy hacking!**
