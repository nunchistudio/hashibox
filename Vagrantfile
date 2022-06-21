# -*- mode: ruby -*-
# vi: set ft=ruby :

image = "20.04"
if ENV['UBUNTU_VERSION']
  image = ENV['UBUNTU_VERSION']
end

Vagrant.configure(2) do |config|

  # Configure the VM options.
  config.vm.box = "bento/ubuntu-#{image}"
  config.vm.hostname = "hashibox"

  # Create 3 nodes acting as servers for Consul, Nomad, and Vault, each exposing
  # a private network.
  (1..3).each do |i|
    config.vm.define "node-server-#{i}" do |node|
      node.vm.hostname = "node-server-#{i}"
      node.vm.network "private_network", ip: "192.168.60.#{i}0"

      node.vm.provider "parallels" do |v|
        v.memory = 512
        v.cpus = 1
      end

      node.vm.provider "virtualbox" do |v|
        v.memory = 512
        v.cpus = 1
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = 512
        v.vmx["numvcpus"] = 1
      end

      node.vm.provision "start_servers", type: "shell", after: :all, run: "always" do |s|
        s.inline = "systemctl restart consul nomad vault"
      end
    end
  end

  # Create 3 nodes acting as clients for Consul and Nomad agents, each exposing
  # a private network. Start Docker as well for running Nomad jobs inside
  # containers.
  (1..3).each do |i|
    config.vm.define "node-client-#{i}" do |node|
      node.vm.hostname = "node-client-#{i}"
      node.vm.network "private_network", ip: "192.168.61.#{i}0"

      node.vm.provider "parallels" do |v|
        v.memory = 1024
        v.cpus = 1
      end

      node.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
      end

      node.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = 1024
        v.vmx["numvcpus"] = 1
      end

      node.vm.provision "start_docker", type: "shell", run: "always" do |s|
        s.inline = "service docker restart"
      end

      node.vm.provision "start_clients", type: "shell", after: :all, run: "always" do |s|
        s.inline = "systemctl restart consul nomad"
      end
    end
  end

  # Remove the previous environment file and create a new one.
  config.vm.provision "envvar_file", type: "shell", run: "always" do |s|
    s.inline = "rm -f /hashibox/.env && touch /hashibox/.env"
  end

  # Write the `CONSUL_HTTP_TOKEN` environment variable to the dedicated file on
  # the virtual machine.
  config.vm.provision "envvar_token_consul", type: "shell", after: "envvar_file", run: "always" do |s|
    s.inline = "echo CONSUL_HTTP_TOKEN=#{ENV['CONSUL_HTTP_TOKEN']} | tee -a /hashibox/.env"
  end

  # Write the `NOMAD_TOKEN` environment variable to the dedicated file on the
  # virtual machine.
  config.vm.provision "envvar_token_nomad", type: "shell", after: "envvar_file", run: "always" do |s|
    s.inline = "echo NOMAD_TOKEN=#{ENV['NOMAD_TOKEN']} | tee -a /hashibox/.env"
  end

  # Write the `VAULT_TOKEN` environment variable to the dedicated file on the
  # virtual machine.
  config.vm.provision "envvar_token_vault", type: "shell", after: "envvar_file", run: "always" do |s|
    s.inline = "echo VAULT_TOKEN=#{ENV['VAULT_TOKEN']} | tee -a /hashibox/.env"
  end

  # We need to manually restart `systemctl` since Vagrant does not provide a
  # proper way for system services to start when Vagrant ups.
  config.vm.provision "start_systemctl", type: "shell", run: "always" do |s|
    s.inline = "systemctl daemon-reload"
  end
end
