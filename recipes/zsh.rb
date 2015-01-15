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
