#
# Cookbook Name:: vampd-developer
# Recipe:: copy
#
# Copyright (C) 2014 Tim Whitney (tim.d.whitney@gmail.com)
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
