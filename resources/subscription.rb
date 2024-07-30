#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook:: wsus-server
# Resource:: subscription
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
unified_mode true

property :categories, Array
property :classifications, Array
property :synchronize_categories, [true, false]
property :configure_timeout, Integer

def initialize(name, run_context = nil)
  super(name, run_context)

  @properties = {}
end

def automatic_synchronization(arg = nil)
  if arg.nil?
    @properties['SynchronizeAutomatically']
  else
    @properties['SynchronizeAutomatically'] = validate_boolean('automatic_synchronization', arg)
  end
end

def synchronization_per_day(arg = nil)
  if arg.nil?
    @properties['NumberOfSynchronizationsPerDay']
  else
    @properties['NumberOfSynchronizationsPerDay'] = validate_integer('synchronization_per_day', arg, 1, 24)
  end
end

def synchronization_time(arg = nil)
  if arg.nil?
    @properties['SynchronizeAutomaticallyTimeOfDay']
  else
    @properties['SynchronizeAutomaticallyTimeOfDay'] = validate_time('synchronization_time', arg)
  end
end
