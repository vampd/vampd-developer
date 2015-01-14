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
  end

  file '/root/.zshrc' do
    owner 'root'
    group 'root'
    mode 0755
    content ::File.open('/root/.oh-my-zsh/templates/zshrc.zsh-template').read
    action :create
  end

  bash 'Change Shell to Oh-my-zsh' do
    user 'root'
    cmd = 'chsh -s `which zsh`'
    code <<-EOH
      set -x
      set -e
      #{cmd}
    EOH
  end
end
