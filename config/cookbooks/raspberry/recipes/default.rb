cookbook_file "/etc/network/interfaces" do
  source "interfaces"
end

apt_package 'iw'
apt_package 'wpasupplicant'

cookbook_file "/boot/wifi.conf" do
	action :create_if_missing
	source "wifi.conf"
end

apt_package 'git'
apt_package 'python-git'
apt_package 'logrotate'

cookbook_file "/etc/logrotate.d/update_chef" do
    source "update_chef_logrotate"
end

cookbook_file "/usr/local/bin/update_chef.py" do
    source "update_chef.py"
    mode '0755'
end

file "/boot/chef-url" do
    action :create_if_missing
    content "http://foo.bar"
end

file "/boot/chef-cookbook" do
    action :create_if_missing
    content ""
end

cookbook_file "/etc/init.d/update_chef" do
    source "update_chef_init"
    mode '0755'
end

service "update_chef" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
    provider Chef::Provider::Service::Init::Debian
end

apt_package 'ruby-dev'
gem_package 'berkshelf'
