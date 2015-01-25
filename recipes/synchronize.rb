#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Attribute:: synchronize
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

sync_timeout = node['wsus_server']['synchronize']['timeout']
powershell_script 'WSUS Update Synchronization' do
  code <<-EOF
    [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
    $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()
    $subscription = $wsus.GetSubscription()

    $subscription.StartSynchronization()
    $timeout = #{sync_timeout}
    if ($timeout -gt 0) {
      $timeout = [DateTime]::Now.AddMinutes($timeout)
      do {
        Start-Sleep -Seconds 5
      } until ($subscription.GetSynchronizationStatus() -eq 'NotProcessing' -or $timeout -lt [DateTime]::Now)
    }
  EOF
end
