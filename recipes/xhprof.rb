package "graphviz" do
  action :install
end

php_pear "xhprof" do
  action :install
  preferred_state "beta"
end

file "/etc/php5/conf.d/xhprof.ini" do
  action :delete
  notifies :restart, "service[apache2]", :delayed
  only_if { File.exists?("/etc/php5/conf.d/xhprof.ini") }
end

template "/etc/php5/conf.d/xhprof.ini" do
  source "xhprof.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end
