# Copy files from a src to a destination.

node[:vampd_developer][:copy].each do |src, des|
  file des do
    owner 'root'
    group 'root'
    mode 0755
    content ::File.open(src).read
    action :create
  end
end
