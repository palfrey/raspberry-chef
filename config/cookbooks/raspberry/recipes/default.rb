cookbook_file '/etc/systemd/network/20-wifi.network' do
    source '20-wifi.network'
end

apt_package 'iw'
apt_package 'wpasupplicant'

cookbook_file "/boot/wifi.conf" do
    action :create_if_missing
    source "wifi.conf"
end

link '/etc/wpa_supplicant/wpa_supplicant.conf' do
    to '/boot/wifi.conf'
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

apt_package 'ruby-dev'
gem_package 'berkshelf' do
    version '4.3.3'
end

service "update_chef" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
    provider Chef::Provider::Service::Systemd
end
