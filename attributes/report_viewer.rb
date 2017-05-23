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

default['wsus_server']['report_viewer']['prerequisite']['name'] = 'Microsoft System CLR Types for SQL Server 2012 (x64)'
default['wsus_server']['report_viewer']['prerequisite']['source'] = 'https://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SQLSysClrTypes.msi'
default['wsus_server']['report_viewer']['prerequisite']['checksum'] = '674c396e9c9bf389dd21cec0780b3b4c808ff50c570fa927b07fa620db7d4537'
default['wsus_server']['report_viewer']['prerequisite']['options'] = '/q'

default['wsus_server']['report_viewer']['runtime']['name'] = 'Microsoft Report Viewer Runtime 2012'
default['wsus_server']['report_viewer']['runtime']['source'] = 'https://download.microsoft.com/download/F/B/7/FB728406-A1EE-4AB5-9C56-74EB8BDDF2FF/ReportViewer.msi'
default['wsus_server']['report_viewer']['runtime']['checksum'] = '948f28452abddd90b27dc80aba1b48c3faedcf2bd42254c71b5b1e19ac5c6daf'
default['wsus_server']['report_viewer']['runtime']['options'] = '/q'
