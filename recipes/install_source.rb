#
# Cookbook Name:: imagemagick
# Recipe:: install_source
#
# Copyright 2009, Chef Software, Inc.
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

include_recipe "build-essential"

src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/#{::File.basename(node['imagemagick']['source']['url'])}"

remote_file node['imagemagick']['source']['url'] do
  path src_filepath
  checksum node['imagemagick']['source']['checksum']
  source node['imagemagick']['source']['url']
  backup false
end

bash "compile_imagemagick_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar -xvzf #{::File.basename(src_filepath)} &&
    cd #{::File.basename(src_filepath, ".tar.gz")} &&
	./configure &&
	make &&
	make install &&
	ldconfig /usr/local/lib
  EOH

  not_if do 
    ::File.directory?(::File.dirname(src_filepath) + '/' + ::File.basename(src_filepath, ".tar.gz"))
  end
end