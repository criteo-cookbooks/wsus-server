#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Library:: base_resource
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
  # Provide base implementation for WsusServer resources
  module BaseResource
    require 'uri'

    def initialize(name, run_context = nil)
      super(name, run_context)

      @action = :configure
      @allowed_actions.push(:configure)

      @properties = {}
    end

    def endpoint(uri = nil)
      @endpoint = validate_http_uri('endpoint', uri) unless uri.nil?
      @endpoint
    end

    def properties(arg = nil)
      @properties = arg.merge(@properties) unless arg.nil?
      @properties
    end

    def validate_string(name, value, values)
      unless values.include? value
        fail RangeError, "Invalid value for '#{name}', accepted values are '#{values.join('\', \'')}'"
      end
      value
    end

    def validate_http_uri(name, value)
      uri = URI value
      uri = URI 'http://' + value unless uri.scheme # also validate the emptyness of the host
      unless %w(http https).include? uri.scheme.to_s.downcase
        fail ArgumentError, "Invalid scheme for '#{name}' URI, accepted schemes are 'http' and 'https'"
      end
      uri
    end

    def validate_boolean(name, value)
      unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
        fail TypeError, "Invalid value for '#{name}' expecting 'True' or 'False'"
      end
      value
    end

    def validate_time(name, value)
      unless value =~ /^([01]?[0-9]|2[0-3])(\:[0-5][0-9]){1,2}$/
        fail ArgumentError, "Invalid value for '#{name}', format is: 'HH:MM:SS'"
      end
      value
    end

    def validate_integer(name, value, min, max)
      i = value.to_i
      unless i >= min && i <= max && value.to_s =~ /^\d+$/
        fail ArgumentError, "Invalid value for '#{name}', value must be between #{min} and #{max}"
      end
      i
    end
  end
end
