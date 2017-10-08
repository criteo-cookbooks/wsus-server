#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Provider:: subscription
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
  @current_resource = Chef::Resource.resource_for_node(:wsus_server_subscription, node).new(@new_resource.name, @run_context)
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
      $objectFormatter = { param($_); $_.psobject.Properties | foreach { "$($_.name): $(&$valueFormatter $_.value)" } }

      $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(#{endpoint_params})
      $subscription = $wsus.GetSubscription()

      # First document is the Subscription configuration
      &$objectFormatter $subscription

      # Second document is the list of enabled categories
      Write-Host '---'
      $subscription.GetUpdateCategories() | foreach { "$($_.Id): $($_.Title)" }

      # Third document is the list of enabled classifications
      Write-Host '---'
      $subscription.GetUpdateClassifications() | foreach { "$($_.Id): $($_.Title)" }
    }
  EOS

  properties, categories, classifications = YAML.load_stream(powershell_out64(script).stdout)

  @category_map = categories || {}
  @classificiation_map = classifications || {}

  @current_resource.properties.merge! properties
  @current_resource.categories @category_map.values
  @current_resource.classifications @classificiation_map.values
end

def compare_array_and_hash(array, hash)
  array.all? { |e| hash.keys.include?(e) || hash.values.include?(e) } if array.size == hash.size
end

action :configure do
  updated_properties = diff_hash(@new_resource.properties, @current_resource.properties)
  categories_unchanged = compare_array_and_hash(@new_resource.categories, @category_map)
  classifications_unchanged = compare_array_and_hash(@new_resource.classifications, @classificiation_map)

  unless updated_properties.empty? && categories_unchanged && classifications_unchanged
    converge_by 'configuring wsus server subscription' do
      script = <<-EOS
        [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null
        # Sets invariant culture for current session to avoid Floating point conversion issue
        [Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture

        $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(#{endpoint_params})
        $conf = $wsus.GetSubscription()
      EOS

      if @new_resource.synchronize_categories
        script << <<-EOS
        $conf.StartSynchronizationForCategoryOnly()

        $timeout = [DateTime]::Now.AddMinutes(15)
        do {
          Start-Sleep -Seconds 5
        } until ($conf.GetSynchronizationStatus() -eq 'NotProcessing' -or $timeout -lt [DateTime]::Now)

        # Renew update server and subscription
        $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer(#{endpoint_params})
        $conf = $wsus.GetSubscription()
        EOS
      end

      unless categories_unchanged
        categories = powershell_value(@new_resource.categories)
        script << <<-EOS
        $cats = #{categories}
        $categories = $wsus.GetUpdateCategories() | where { ([Array]::IndexOf($cats, $_.Title) -ne -1) -or ([Array]::IndexOf($cats, $_.Id.ToString()) -ne -1) }
        if ($categories -ne $null)
        {
          $collection = New-Object Microsoft.UpdateServices.Administration.UpdateCategoryCollection
          $collection.AddRange($categories)
          $conf.SetUpdateCategories($collection)
        }
        EOS
      end

      unless classifications_unchanged
        classifications = powershell_value(@new_resource.classifications)
        script << <<-EOS
        $clas = #{classifications}
        $classifications = $wsus.GetUpdateClassifications() | where { ([Array]::IndexOf($clas, $_.Title) -ne -1) -or ([Array]::IndexOf($clas, $_.Id.ToString()) -ne -1) }
        if ($classifications -ne $null)
        {
          $collection = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
          $collection.AddRange($classifications)
          $conf.SetUpdateClassifications($collection)
        }
        EOS
      end

      updated_properties.each do |k, v|
        script << "      $conf.#{k} = #{powershell_value(v)}\n"
      end
      script << '      $conf.Save()'

      powershell_out64(script, @new_resource.configure_timeout)
    end
    new_resource.updated_by_last_action true
  end
end
