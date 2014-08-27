#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Attribute:: report_viewer
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

default['wsus_server']['report_viewer']['name'] = 'Microsoft Report Viewer Redistributable 2008 SP1'
default['wsus_server']['report_viewer']['source'] = 'http://download.microsoft.com/download/3/a/e/3aeb7a63-ade6-48c2-9b6a-d3b6bed17fe9/ReportViewer.exe'
default['wsus_server']['report_viewer']['checksum'] = '1a0e41b1d82125ae214d3fc1e69b55c4e2dfa060f287290874ca2874b78f86a9'
default['wsus_server']['report_viewer']['options'] = '/q'
