#!/bin/bash

set -eux -o pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y chef git build-essential
systemctl stop chef-client
systemctl mask chef-client
if [ ! -d "/chef_bootstrap" ]; then
	git clone https://github.com/palfrey/raspberry-chef /chef_bootstrap
fi
cd /chef_bootstrap/config
rm -Rf local-mode-cache # Won't exist on first run, but for later ones this avoids caching
chef-client -z -o raspberry -c client.rb
