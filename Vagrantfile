# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/chef_bootstrap"
  config.vm.provision "shell", path: "bootstrap.sh"
end
