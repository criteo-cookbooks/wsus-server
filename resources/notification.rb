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

FREQUENCY_VALUES = ['daily', 'weekly']

def enable_sync_notification(arg=nil)
  if arg
    @properties['SendSyncNotification'] = validate_boolean('enable_sync_notification', arg)
  else
    @properties['SendSyncNotification']
  end
end

def enable_smtp_authentication(arg=nil)
  if arg
    @properties['SmtpServerRequiresAuthentication'] = validate_boolean('enable_smtp_authentication', arg)
  else
    @properties['SmtpServerRequiresAuthentication']
  end
end

def enable_status_notification(arg=nil)
  if arg
    @properties['SendStatusNotification'] = validate_boolean('enable_status_notification', arg)
  else
    @properties['SendStatusNotification']
  end
end

def language(arg=nil)
  if arg
    @properties['EmailLanguage'] = arg
  else
    @properties['EmailLanguage']
  end
end

def sender_address(arg=nil)
  if arg
    @properties['SenderEmailAddress'] = arg
  else
    @properties['SenderEmailAddress']
  end
end

def sender_name(arg=nil)
  if arg
    @properties['SenderDisplayName'] = arg
  else
    @properties['SenderDisplayName']
  end
end

def smtp_host(arg=nil)
  if arg
    @properties['SmtpHostName'] = arg
  else
    @properties['SmtpHostName']
  end
end

def smtp_password(arg=nil)
  set_or_return(:smtp_password, arg, :kind_of => String)
end

def smtp_port(arg=nil)
  if arg
    @properties['SmtpPort'] = validate_integer('smtp_port', arg, 0, 65535)
  else
    @properties['SmtpPort']
  end
end

def smtp_user(arg=nil)
  if arg
    @properties['SmtpUserName'] = arg
  else
    @properties['SmtpUserName']
  end
end

def status_notification_frequency(arg=nil)
  if arg
    @properties['StatusNotificationFrequency'] = validate_string('status_notification_frequency', arg, FREQUENCY_VALUES)
  else
    @properties['StatusNotificationFrequency']
  end
end

def status_notification_time(arg=nil)
  if arg
    @properties['StatusNotificationTimeOfDay'] = validate_time('status_notification_time', arg)
  else
    @properties['StatusNotificationTimeOfDay']
  end
end
