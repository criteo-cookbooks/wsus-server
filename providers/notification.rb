#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Provider:: notification
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
use_inline_resources

include WsusServer::BaseProvider

def load_current_resource
  @current_resource = Chef::Resource.resource_for_node(:wsus_server_notification, node).new(@new_resource.name, @run_context)
  # Load current_resource from Powershell
  script = <<-EOS
  $assembly = [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration')
  if ($assembly -ne $null) {
    # Sets buffer size to avoid 80 column limitation, a width greater than 1000 is useless
    $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(1000, $Host.UI.RawUI.BufferSize.Height)
    # Sets invariant culture for current session to avoid Floating point conversion issue
    [Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

    # Defines single-level "YAML" formatters to avoid DateTime and TimeSpan conversion issue in ruby
    $valueFormatter = { param($_); if ($_ -is [DateTime] -or $_ -is [TimeSpan]) { "'$($_)'" } else { $_ } }
    $objectFormatter = { param($_); $_.psobject.Properties | foreach { if ($_.IsSettable) { "$($_.name): $(&$valueFormatter $_.value)" } } }

    $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(#{endpoint_params})
    &$objectFormatter $wsus.GetEmailNotificationConfiguration()
  }
  EOS

  @current_resource.properties.merge! YAML.load(powershell_out64(script).stdout)
end

action :configure do
  updated_properties = diff_hash(@new_resource.properties, @current_resource.properties)
  if !updated_properties.empty? || @new_resource.smtp_password
    converge_by 'configuring Wsus email notification' do
      script = <<-EOS
      [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
      # Sets invariant culture for current session to avoid Floating point conversion issue
      [Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

      $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(#{endpoint_params})
      $conf = $wsus.GetEmailNotificationConfiguration()
      EOS

      updated_properties.each do |k, v|
        script << "$conf.#{k} = #{powershell_value(v)}\n"
      end

      script << "$conf.SetSmtpUserPassword(#{powershell_value(@new_resource.smtp_password)})" if @new_resource.smtp_password
      script << '$conf.Save()'

      powershell_out64 script
    end
    new_resource.updated_by_last_action true
  end
end
