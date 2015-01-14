# Copy files from a src to a destination.

node[:vampd_developer][:copy].each do |src, destinations|
  destinations.each do |des|
    Chef::Log.info("Copied File from #{src} to #{des}")
    file des do
      content IO.read(src)
      action :create
    end
  end
end
