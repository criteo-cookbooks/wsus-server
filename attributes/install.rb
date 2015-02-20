#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Attribute:: install
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

#-----
# Setup attributes are based on WSUS unattend install properties:
# => http://technet.microsoft.com/library/dd939814.aspx
# And also 'Managing WSUS from the Command line'
# => https://technet.microsoft.com/library/cc720466.aspx
#-----

# Defines the directory where content is stored, it also enables local storage of wsus content.
default['wsus_server']['setup']['content_dir']                  = nil
# Defines the local or remote SQL instance used for WSUS configuration database.
default['wsus_server']['setup']['sqlinstance_name']             = nil

# Following attributes are not required anymore on Windows Server 2012 and later
if node['platform_version'].to_f < 6.2
  # Enables the inventory feature.
  default['wsus_server']['setup']['enable_inventory']           = false
  # Determines whether WSUS should be setup as an additional frontend server.
  # Frontend server shares the configuration of the main server, using the value of above attribute sqlinstance_name.
  # see http://technet.microsoft.com/en-us/library/dd939896.aspx
  default['wsus_server']['setup']['frontend_setup']             = false
  # Joins the Microsoft Update Improvement Program.
  default['wsus_server']['setup']['join_improvement_program']   = false
  # Determines whether WSUS should be set as default website - port 80 - or not - port 8530.
  default['wsus_server']['setup']['use_default_website']        = false
  # Defines path to windows internal database data directory.
  default['wsus_server']['setup']['wyukon_data_dir']            = nil

  default['wsus_server']['package']['name']                     = 'Windows Server Update Services 3.0 SP2'
  default['wsus_server']['package']['options']                  = '/q'
  if node['kernel']['machine'] == 'x86_64'
    default['wsus_server']['package']['source']                 = 'http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x64.exe'
    default['wsus_server']['package']['checksum']               = '50d027431d64c35ad62291825eed35d7ffd3c3ecc96421588465445e195571d0'
  else
    default['wsus_server']['package']['source']                 = 'http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x86.exe'
    default['wsus_server']['package']['checksum']               = 'bec8bdd6cdad1edd50cc43e6121b73188b31ba4ad08e55b49f4287923a7f3290'
  end
end
