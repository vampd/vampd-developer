# Install xhprof.io
git "#{node[:vampd_developer][:server_base]}/xhprof.io" do
  repository 'https://github.com/gajus/xhprof.io.git'
  reference 'master'
  action :sync
end

passwords = data_bag_item('users', 'mysql')[node.chef_environment]
Chef::Log::debug 'drupal::mysql passwords = #{passwords.inspect}'

if Chef::Config[:solo]
  Chef::Log.debug 'drupal::mysql Setting chef solo node mysql passwords.'
  node.set['mysql']['server_debian_password'] = passwords['debian'] unless passwords['debian'].nil?
  node.default[:mysql][:server_root_password] = passwords['root'] unless passwords['root'].nil?
  node.set['mysql']['server_repl_password'] = passwords['replication'] unless passwords['replication'].nil?
end

mysql_connection_info = {
  :host => node[:db][:host],
  :username => node[:db][:root],
  :password => node[:mysql][:server_root_password]
}

mysql_database 'xhprof_io' do
  connection mysql_connection_info
  action :create
end

mysql_database 'xhprof_io' do
  connection mysql_connection_info
  sql { ::File.open("#{node[:drupal_developer][:server_base]}/xhprof.io/setup/database.sql").read }
  action :query
end

file '/etc/php5/conf.d/xhprof.io.ini' do
  action :delete
  notifies :restart, 'service[apache2]', :delayed
  only_if { File.exists?('/etc/php5/conf.d/xhprof.io.ini') }
end

template '/etc/php5/conf.d/xhprof.io.ini' do
  source 'xhprof.io.ini.erb'
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end

file "#{node[:vampd_developer][:server_base]}/xhprof.io/xhprof/includes/config.inc.php" do
  action :delete
  notifies :restart, 'service[apache2]', :delayed
  only_if { File.exists?('/etc/php5/conf.d/xhprof.io.ini') }
end

template "#{node[:vampd_developer][:server_base]}/xhprof.io/xhprof/includes/config.inc.php" do
  source 'xhprof.io.config.erb'
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end
