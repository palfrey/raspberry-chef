#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
apt-get install -y chef
if [ ! -d "/chef_bootstrap" ]; then
	git clone http://github.com/palfrey/raspberry-chef /chef_bootstrap
fi
cd /chef_bootstrap/config
chef-client -z -o raspberry -c client.rb
