#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Resource:: configuration
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
include WsusServer::BaseResource

default_action :configure

def initialize(name, run_context = nil)
  super(name, run_context)

  # Default computed value for master_server is nil
  @properties['UpstreamWsusServerName'] = nil
  @properties['SyncFromMicrosoftUpdate'] = true
  @properties['IsReplicaServer'] = false
end

def master_server(arg = nil)
  if arg.nil?
    if @properties['IsReplicaServer'] == true && properties['SyncFromMicrosoftUpdate'] == false
      uri = URI ''
      uri.scheme = @properties['UpstreamWsusServerUseSsl'] ? 'https' : 'http'
      uri.host = @properties['UpstreamWsusServerName']
      uri.port = @properties['UpstreamWsusServerPortNumber'].to_i if @properties['UpstreamWsusServerPortNumber']

      uri
    end
  else
    uri = validate_http_uri('upstream_server', arg)

    @properties['UpstreamWsusServerName'] = uri.host
    @properties['UpstreamWsusServerPortNumber'] = uri.port.to_i
    @properties['UpstreamWsusServerUseSsl'] = 'https'.casecmp(uri.scheme).zero?
    @properties['SyncFromMicrosoftUpdate'] = false
    @properties['IsReplicaServer'] = true
  end
end

def proxy_password(arg = nil)
  set_or_return(:proxy_password, arg, kind_of: String)
end

def update_languages(arg = nil)
  set_or_return(:update_languages, arg, kind_of: Array)
end
