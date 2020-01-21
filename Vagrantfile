# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/contrib-buster64" # not buster64 to workaround guest additions issues https://lists.debian.org/debian-cloud/2019/09/msg00056.html
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/chef_bootstrap"
  config.vm.provision "shell", path: "bootstrap.sh"
end
