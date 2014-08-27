#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
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

include_recipe 'iis'
include_recipe 'wsus-server::report_viewer'


setup_conf = node['wsus_server']['setup']
package_info = node['wsus_server']['package']

setup_options = package_info['options']
setup_options << ' ENABLE_INVENTORY=' + (setup_conf['enable_inventory'] ? '1' : '0')
setup_options << ' MU_ROLLUP=' + (setup_conf['join_improvement_program'] ? '1' : '0')
setup_options << ' DEFAULT_WEBSITE=' + (setup_conf['use_default_website'] ? '1' : '0')
setup_options << ' FRONTEND_SETUP=1 CREATE_DATABASE=0'                            if setup_conf['frontend_setup']
setup_options << " SQLINSTANCE_NAME=\"#{setup_conf['sqlinstance_name']}\""        if setup_conf['sqlinstance_name']

if setup_conf['content_dir']
  setup_options << " CONTENT_LOCAL=1 CONTENT_DIR=\"#{setup_conf['content_dir']}\""
  directory setup_conf['content_dir'] { recursive true }
end

if setup_conf['wyukon_data_dir']
  setup_options << " WYUKON_DATA_DIR=\"#{setup_conf['wyukon_data_dir']}\""
  directory setup_conf['wyukon_data_dir'] { recursive true }
end

windows_package package_info['name'] do
  action                                         :install
  installer_type                                 :custom
  options                                        setup_options
  source                                         package_info['source']
  checksum                                       package_info['checksum']
end

# Wsus does not need configuration when setup as frontend server
include_recipe 'wsus-server::configure'          unless setup_conf['frontend_setup']
