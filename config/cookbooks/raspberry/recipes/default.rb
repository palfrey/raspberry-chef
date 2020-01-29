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

file "/boot/chef-directory" do
    action :create_if_missing
    content ""
end

execute 'systemctl daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
end

directory '/usr/local/lib/systemd/system' do
    recursive true
end

cookbook_file '/usr/local/lib/systemd/system/update_chef.service' do
    source 'update_chef.service'
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    notifies :restart, 'service[update_chef]'
end

apt_package 'ruby-dev'
apt_package 'build-essential'

gem_package 'berkshelf' do
    version '4.3.3'
end

service "update_chef" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
    provider Chef::Provider::Service::Systemd
end

# Support for TP-Link Archer T2U AC600
apt_package 'dkms'

machine_path = "/usr/src/linux-headers-#{node['os_version']}/arch/#{node['kernel']['machine']}"
cpu_path = "/usr/src/linux-headers-#{node['os_version']}/arch/#{node['languages']['ruby']['target_cpu']}"

unless machine_path == cpu_path
    link machine_path do
        to cpu_path
    end
end

execute 'dkms add' do
    command 'dkms add -m rtl8812au -v 5.3.4'
    action :nothing
end

execute 'dkms build' do
    command 'dkms build -m rtl8812au -v 5.3.4'
    action :nothing
end

execute 'dkms install' do
    command 'dkms install -m rtl8812au -v 5.3.4'
    action :nothing
end

git '/usr/src/rtl8812au-5.3.4' do
    repository 'https://github.com/jeremyb31/rtl8812au-1.git'
    revision 'v5.3.4'
    action :sync
    notifies :run, 'execute[dkms add]', :immediately
    notifies :run, 'execute[dkms build]', :immediately
    notifies :run, 'execute[dkms install]', :immediately
end