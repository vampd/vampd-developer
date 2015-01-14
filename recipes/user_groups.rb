# Place users in certain groups.

node[:vampd_developer][:user_groups].each do |group_name, users|
  group group_name do
    action :modify
    members users
    append true
  end
end
