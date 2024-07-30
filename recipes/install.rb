#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook:: wsus-server
# Recipe:: install
#
# Copyright:: Copyright (c) 2014 Criteo.
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
# WSUS is a windows only feature
return unless platform?('windows')

setup_conf = node['wsus_server']['setup']

setup_options = ''
setup_options << " SQL_INSTANCE_NAME=\"#{setup_conf['sqlinstance_name']}\"" if setup_conf['sqlinstance_name']

if setup_conf['content_dir']
  setup_options << " CONTENT_LOCAL=1 CONTENT_DIR=\"#{setup_conf['content_dir']}\""

  directory setup_conf['content_dir'] do
    recursive true
  end
end

[
  'NET-WCF-HTTP-Activation45', # This feature is required for KB3159706
  'UpdateServices',
  'UpdateServices-UI',
].each do |feature_name|
  windows_feature feature_name do
    action         :install
    install_method :windows_feature_powershell if respond_to? :install_method
    provider       :windows_feature_powershell unless respond_to? :install_method
  end
end

windows_feature 'UpdateServices-WidDB' do
  action         setup_conf['sqlinstance_name'] ? :remove : :install
  all            true
  install_method :windows_feature_powershell if respond_to? :install_method
  provider       :windows_feature_powershell unless respond_to? :install_method
end

windows_feature 'UpdateServices-DB' do
  action         setup_conf['sqlinstance_name'] ? :install : :remove
  all            true
  install_method :windows_feature_powershell if respond_to? :install_method
  provider       :windows_feature_powershell unless respond_to? :install_method
end

guard_file = ::File.join(Chef::Config['file_cache_path'], 'wsus_postinstall')
execute 'WSUS PostInstall' do
  command        "WsusUtil.exe PostInstall #{setup_options}"
  cwd            'C:\Program Files\Update Services\Tools'
  not_if { ::File.exist?(guard_file) && ::File.read(guard_file) == setup_options }
end

file guard_file do
  path           guard_file
  content        setup_options
end

# Wsus does not need configuration when setup as frontend server
include_recipe 'wsus-server::configure' unless setup_conf['frontend_setup']
