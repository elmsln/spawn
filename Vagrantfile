# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # centos 7
  config.vm.box = "bradallenfisher/centos7"
  # ip address
  config.vm.network "private_network", ip: "192.168.33.33"
  # host name
  config.vm.hostname = "local.spawn.dev"

  # run script as root
  config.vm.provision "shell",
    path: "scripts/install/root.sh"
    # run script as vagrant user

  config.vm.provision "shell",
    path: "scripts/install/user.sh",
    privileged: FALSE

  # virtual box name
  config.vm.provider "virtualbox" do |v|
    v.name = "spawn"
    v.memory = 4096
  end
end
