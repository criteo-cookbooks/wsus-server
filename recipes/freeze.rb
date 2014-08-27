#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus
# Attribute:: server_freeze
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

include_recipe 'wsus-server::install'
include_recipe 'powershell::powershell4'

::Chef::Recipe.send(:include, ::Chef::Mixin::PowershellOut)

freeze = node['wsus_server']['freeze']
# Chef does not have guard_interpreter feature before 11.12.0
guard_cmd = <<-EOH
  [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
  $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
  $wsus.GetComputerTargetGroups() | where Name -eq '#{freeze}') -ne $null
EOH
if powershell_out(guard_cmd).stdout == 'True'
  powershell_script 'WSUS Update Freeze' do
    code <<-EOH
      [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
      $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()

      $freeze_name = '#{freeze}'

      $group = $wsus.GetComputerTargetGroups() | where Name -eq $freeze_name
      if ($group -eq $null) {
        $group = $wsus.CreateComputerTargetGroup($freeze_name)

        $wsus.GetUpdates() | foreach { $_.Approve('Install', $group) }
      }
    EOH
  end
end
