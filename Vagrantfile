# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
export DEBIAN_FRONTEND=noninteractive
apt-get install -y chef python
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false
  config.vm.synced_folder "config", "/data"
  config.vm.provision "shell", inline: $script
end
