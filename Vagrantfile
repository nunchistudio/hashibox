# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Configure the VM options.
  config.vm.box = "bento/ubuntu-21.04"
  config.vm.hostname = "hashibox"

  # Create 3 nodes acting as servers for Consul, Vault, and Nomad agents, each
  # exposing a private network.
  (1..3).each do |i|
    config.vm.define "node-server-#{i}" do |node|
      node.vm.hostname = "node-server-#{i}"
      node.vm.network "private_network", ip: "192.168.60.#{i}0"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.cpus = 1
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = 512
        v.vmx["numvcpus"] = 1
      end
    end
  end

  # Create 3 nodes acting as clients for Consul, Vault, and Nomad agents, each
  # exposing a private network.
  (1..3).each do |i|
    config.vm.define "node-client-#{i}" do |node|
      node.vm.hostname = "node-client-#{i}"
      node.vm.network "private_network", ip: "192.168.61.#{i}0"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = 1024
        v.vmx["numvcpus"] = 1
      end
    end
  end

  # Remove the previous environment file and create a new one.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "rm /hashibox/.env && touch /hashibox/.env"
  end

  # Write the `CONSUL_HTTP_TOKEN` environment variable to the dedicated file on
  # the virtual machine.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "echo CONSUL_HTTP_TOKEN=#{ENV['CONSUL_HTTP_TOKEN']} | tee -a /hashibox/.env"
  end

  # Write the `VAULT_TOKEN` environment variable to the dedicated file on the
  # virtual machine.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "echo VAULT_TOKEN=#{ENV['VAULT_TOKEN']} | tee -a /hashibox/.env"
  end

  # Write the `NOMAD_TOKEN` environment variable to the dedicated file on the
  # virtual machine.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "echo NOMAD_TOKEN=#{ENV['NOMAD_TOKEN']} | tee -a /hashibox/.env"
  end

  # We need to manually restart `systemctl` since Vagrant does not provide a
  # proper way for system services to start when Vagrant ups.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "systemctl daemon-reload"
  end

  # We can then restart the Docker service.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "service docker restart"
  end

  # We also need to restart the Consul, Vault, and Nomad and services.
  config.vm.provision "shell", preserve_order: true, run: "always" do |s|
    s.inline = "systemctl restart consul vault nomad"
  end
end
