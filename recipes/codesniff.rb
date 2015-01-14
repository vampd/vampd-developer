#
# Cookbook Name:: drupal-developer
# Recipe:: codesniff
#
# Copyright (C) 2014 Alex Knoll <arknoll@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

username = node[:vampd_developer][:codesniff_user]

home = Dir.home(username)

# Install coder module.
directory "#{home}/.drush" do
  owner username
  group username
  mode '0755'
  recursive true
  action :create
end

bash 'Install coder module.' do
  not_if { ::File.directory?("#{home}/.drush/coder") }
  user 'root'
  cwd home
  cmd = "drush pm-download coder --destination=#{home}/.drush && drush cache-clear drush"
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
  file "#{home}/.bash_aliases" do
    owner username
    group username
    mode '0755'
    action :create
  end

  content = <<-eof
  alias drupalcs="phpcs --standard=#{home}/.drush/coder/coder_sniffer/Drupal --extensions='php,module,inc,install,test,profile,theme,js,css,info,txt'"
    eof

  bash 'Add alias to .bash_aliases' do
    code <<-EOT
      echo '#{content}' >> #{home}/.bash_aliases
    EOT
    not_if "grep '#{content}' #{home}/.bash_aliases"
  end
end
