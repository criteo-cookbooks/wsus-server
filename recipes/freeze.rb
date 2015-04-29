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


freeze = node['wsus_server']['freeze']['name']

powershell_script 'WSUS Update Freeze' do # ~FC009
  code <<-EOH
    [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
    $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()

    $freeze_name = '#{freeze}'

    $group = $wsus.GetComputerTargetGroups() | where Name -eq $freeze_name
    if ($group -eq $null) {
      Try {
        $group = $wsus.CreateComputerTargetGroup($freeze_name)

        $wsus.GetUpdates() | foreach {
          if ($_.RequiresLicenseAgreementAcceptance) {
            $_.AcceptLicenseAgreement()
          }
          $_.Approve('Install', $group)
        }
      }
      Catch {
        if ($group -ne $null) {
          $group.Delete()
        }
      }
    }
  EOH
  guard_interpreter :powershell_script
  only_if <<-EOH
      [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
      $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
      ($wsus.GetComputerTargetGroups() | where Name -eq '#{freeze}') -eq $null
  EOH
end
