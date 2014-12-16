# Install coder module.

directory "/home/vagrant/.drush" do
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
end

bash 'Install coder module.' do
  not_if { ::File.directory?('/home/vagrant/.drush/coder') }
  user 'root'
  cwd '/home/vagrant'
  cmd = 'drush pm-download coder --destination=/home/vagrant/.drush && drush cache-clear drush'
  code <<-EOH
    set -x
    set -e
    #{cmd}
  EOH
end

# Install PHP Codesniffer.
php_pear 'PHP_CodeSniffer' do
  version '1.4.2'
  action :install
end

# Add alias.
if platform?('ubuntu')
  file '/home/vagrant/.bash_aliases' do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    action :create
  end

  content = <<-eof
  alias drupalcs="phpcs --standard=/home/vagrant/.drush/coder/coder_sniffer/Drupal --extensions='php,module,inc,install,test,profile,theme,js,css,info,txt'"
    eof

  bash 'Add alias to .bash_aliases' do
    code <<-EOT
      echo '#{content}' >> /home/vagrant/.bash_aliases
    EOT
    not_if "grep '#{content}' /home/vagrant/.bash_aliases"
  end
end
