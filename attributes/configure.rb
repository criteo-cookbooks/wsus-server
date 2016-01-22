#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Attribute:: server_configuration
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

# -----
# Following configuration attributes are based on the IUpdateServerConfiguration interface
# => http://msdn.microsoft.com/en-us/library/Microsoft.UpdateServices.Administration.IUpdateServerConfiguration_members.aspx
# -----

# Defines the password to use when accessing the proxy server.
default['wsus_server']['configuration']['proxy_password']               = nil
# Enables update for the specified list of languages.
default['wsus_server']['configuration']['update_languages']             = ['en']
# Defines the upstream server and set the current server as its replica:
# => it configures the WSUS server as Replica of the upstream server.
# => it uses the scheme of the provided URI to determines whether to use SSL or not.
default['wsus_server']['configuration']['master_server']                = nil
# Allows to configure any IUpdateServerConfiguration's writable properties (explicit attributes prevails)
default['wsus_server']['configuration']['properties']                   = {}
# Determines the targeting mode:
# => client = Clients specify the target group to which they belong.
# => server = Servers specify the target group to which the clients belong.
default['wsus_server']['configuration']['properties']['TargetingMode']  = 'Client'

# -----
# Following subscription attributes are based on the ISubscription interface
# => http://msdn.microsoft.com/en-us/library/microsoft.updateservices.administration.isubscription_members.aspx
# -----

# Determines whether the WSUS server synchronizes the updates automatically
default['wsus_server']['subscription']['automatic_synchronization']     = true
# Defines the list of categories of updates that you want the WSUS server to synchronize. (Id or Title)
default['wsus_server']['subscription']['categories']                    = []
# Defines the list of classifications of updates that you want the WSUS server to synchronize. (Id or Title)
default['wsus_server']['subscription']['classifications']               = []
# Allows to configure any ISubscription's writable properties (explicit attributes prevails)
default['wsus_server']['subscription']['properties']                    = {}
# Defines the number of server-to-server synchronizations a day.
default['wsus_server']['subscription']['synchronization_per_day']       = '12'
# Defines the time of day when the WSUS server automatically synchronizes the updates.
default['wsus_server']['subscription']['synchronization_time']          = '00:00:00'
# Determines whether WSUS should synchronize categories before configuring above attributes.
default['wsus_server']['subscription']['synchronize_categories']        = true
# Defines the timeout in seconds for the subscription configuration (including category synchronization if synchronize_categories is true)
default['wsus_server']['subscription']['configure_timeout']             = 900

# -----
# Following notification attributes are based on the IEmailNotificationConfiguration interface
# => http://msdn.microsoft.com/en-us/library/microsoft.updateservices.administration.iemailnotificationconfiguration_members.aspx
# -----

# Determines whether the new update alerts should be sent.
default['wsus_server']['notification']['enable_sync_notification']      = false
# Determines whether the SMTP server requires authentication.
default['wsus_server']['notification']['enable_smtp_authentication']    = false
# Determines whether the new update status summaries should be sent.
default['wsus_server']['notification']['enable_status_notification']    = false
# Defines the e-mail language setting.
default['wsus_server']['notification']['language']                      = 'en'
# Configures any IEmailNotificationConfiguration's writable properties (explicit attributes prevails)
default['wsus_server']['notification']['properties']                    = {}
# Defines the e-mail address of the notification sender.
default['wsus_server']['notification']['sender_address']                = nil
# Defines the name of the notification sender.
default['wsus_server']['notification']['sender_name']                   = nil
# Defines the host name of the SMTP server used by notifications.
default['wsus_server']['notification']['smtp_host']                     = nil
# Defines the e-mail sender's password.
default['wsus_server']['notification']['smtp_password']                 = nil
# Defines the port of the SMTP server used for notifications.
default['wsus_server']['notification']['smtp_port']                     = 25
# Defines the e-mail sender's account name.
default['wsus_server']['notification']['smtp_user']                     = nil
# Defines the frequency with which e-mail notifications should be sent: 'Daily' or 'Weekly'.
default['wsus_server']['notification']['status_notification_frequency'] = 'Daily'
# Defines the time of the day e-mail notifications should be sent.
default['wsus_server']['notification']['status_notification_time']      = '00:00:00'
