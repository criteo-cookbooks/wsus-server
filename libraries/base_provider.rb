#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Library:: base_provider
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
module WsusServer
  # Provide helpers methods to WsusServer providers
  module BaseProvider
    require 'uri'
    require 'yaml'
    require 'base64'
    include Chef::Mixin::ShellOut
    include Windows::Helper

    def whyrun_supported?
      true
    end

    def self.uri_to_wsus_endpoint_params(uri)
      uri = URI uri
      "'#{uri.host}', #{'https'.casecmp(uri.scheme).zero?}, #{uri.port}"
    end

    def array_equals(arr1, arr2)
      arr1.is_a?(Array) && arr2.is_a?(Array) && arr1.sort == arr2.sort
    end

    def diff_hash(hash1, hash2)
      hash1.find_all do |k, v|
        old_val = hash2[k]
        v.is_a?(Array) ? !array_equals(v, old_val) : v != old_val
      end
    end

    def endpoint_params
      @endpoint ||= @new_resource.endpoint ? WsusServer::BaseProvider.uri_to_wsus_endpoint_params(@new_resource.endpoint) : ''
    end

    def powershell
      locate_sysnative_cmd('powershell.exe')
    end

    def powershell_out64(cmd, timeout=300)
      flags = [
        # Hides the copyright banner at startup.
        '-NoLogo',
        # Does not present an interactive prompt to the user.
        '-NonInteractive',
        # Does not load the Windows PowerShell profile.
        '-NoProfile',
        # always set the ExecutionPolicy flag
        # see http://technet.microsoft.com/en-us/library/ee176961.aspx
        '-ExecutionPolicy RemoteSigned',
        # Powershell will hang if STDIN is redirected
        # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
        '-InputFormat None',
      ]

      encoded_command = Base64.strict_encode64(cmd.encode('UTF-16LE', 'UTF-8'))
      # Use powershell with absolute path to the binary (it's the same path for all versions)
      # Use the locate_sysnative helper to target the right powershell binary
      # => https://msdn.microsoft.com/en-us/library/windows/desktop/aa384187.aspx
      cmd = shell_out "#{powershell} #{flags.join(' ')} -EncodedCommand #{encoded_command}", timeout: timeout
      cmd.error!
      fail 'Invalid syntax in PowershellScript' if cmd.stderr && cmd.stderr.include?('ParserError')
      cmd
    end

    def powershell_value(val)
      case val
      when FalseClass
        'false'
      when Array
        "@(#{val.map { |v| powershell_value(v) }.join(',')})"
      when Hash
        "@{#{val.map { |k, v| "'#{k}' = " + powershell_value(v) }.join('; ')}}"
      else
        "'#{val}'"
      end
    end
  end
end
