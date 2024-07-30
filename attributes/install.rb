#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook:: wsus-server
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
