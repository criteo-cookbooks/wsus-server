#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Resource:: notification
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

FREQUENCY_VALUES = %w(Daily Weekly)

def enable_sync_notification(arg = nil)
  if arg.nil?
    @properties['SendSyncNotification']
  else
    @properties['SendSyncNotification'] = validate_boolean('enable_sync_notification', arg)
  end
end

def enable_smtp_authentication(arg = nil)
  if arg.nil?
    @properties['SmtpServerRequiresAuthentication']
  else
    @properties['SmtpServerRequiresAuthentication'] = validate_boolean('enable_smtp_authentication', arg)
  end
end

def enable_status_notification(arg = nil)
  if arg.nil?
    @properties['SendStatusNotification']
  else
    @properties['SendStatusNotification'] = validate_boolean('enable_status_notification', arg)
  end
end

def language(arg = nil)
  if arg.nil?
    @properties['EmailLanguage']
  else
    @properties['EmailLanguage'] = arg
  end
end

def sender_address(arg = nil)
  if arg.nil?
    @properties['SenderEmailAddress']
  else
    @properties['SenderEmailAddress'] = arg
  end
end

def sender_name(arg = nil)
  if arg.nil?
    @properties['SenderDisplayName']
  else
    @properties['SenderDisplayName'] = arg
  end
end

def smtp_host(arg = nil)
  if arg.nil?
    @properties['SmtpHostName']
  else
    @properties['SmtpHostName'] = arg
  end
end

def smtp_password(arg = nil)
  set_or_return(:smtp_password, arg, kind_of: String)
end

def smtp_port(arg = nil)
  if arg.nil?
    @properties['SmtpPort']
  else
    @properties['SmtpPort'] = validate_integer('smtp_port', arg, 0, 65_535)
  end
end

def smtp_user(arg = nil)
  if arg.nil?
    @properties['SmtpUserName']
  else
    @properties['SmtpUserName'] = arg
  end
end

def status_notification_frequency(arg = nil)
  if arg.nil?
    @properties['StatusNotificationFrequency']
  else
    @properties['StatusNotificationFrequency'] = validate_string('status_notification_frequency', arg, FREQUENCY_VALUES)
  end
end

def status_notification_time(arg = nil)
  if arg.nil?
    @properties['StatusNotificationTimeOfDay']
  else
    @properties['StatusNotificationTimeOfDay'] = validate_time('status_notification_time', arg)
  end
end
