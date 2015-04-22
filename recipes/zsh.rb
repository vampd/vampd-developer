#
# Cookbook Name:: vampd-developer
# Recipe:: zsh
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

# Oh My ZSH install
if node[:vampd_developer][:zsh]
  if platform?('ubuntu')
    package 'zsh' do
      action :install
    end
  end

  git "/root/.oh-my-zsh" do
    repository 'http://github.com/robbyrussell/oh-my-zsh.git'
    reference 'master'
    action :sync
    notifies :run, "bash[copy zshrc]", :immediately
  end

  bash 'copy zshrc' do
    user 'root'
    cmd = 'cp /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc'
    code <<-EOH
      set -x
      set -e
      #{cmd}
    EOH
    action :nothing
    notifies :run, 'bash[Change Shell to Oh-my-zsh]', :immediately
  end

  bash 'Change Shell to Oh-my-zsh' do
    user 'root'
    cmd = 'chsh -s `which zsh`'
    code <<-EOH
      set -x
      set -e
      #{cmd}
    EOH
    action :nothing
  end
end
