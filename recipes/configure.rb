#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: wsus-server
# Recipe:: configure
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

# Updates main server settings
server_conf = node['wsus_server']['configuration']
wsus_server_configuration 'Wsus server configuration' do
  master_server                                    server_conf['master_server']
  update_languages                                 server_conf['update_languages']
  properties                                       server_conf['properties']
end

unless server_conf['master_server'] || server_conf['properties']['IsReplicaServer']
  # Updates subscription settings
  subscription_conf = node['wsus_server']['subscription']
  wsus_server_subscription 'Wsus server subscription' do
    automatic_synchronization                      subscription_conf['automatic_synchronization']
    categories                                     subscription_conf['categories']
    classifications                                subscription_conf['classifications']
    properties                                     subscription_conf['properties']
    synchronization_per_day                        subscription_conf['synchronization_per_day']
    synchronization_time                           subscription_conf['synchronization_time']
    synchronize_categories                         subscription_conf['synchronize_categories']
    configure_timeout                              subscription_conf['configure_timeout']
  end

  # Updates notification settings
  notification_conf = node['wsus_server']['notification']
  wsus_server_notification 'Wsus server notification' do
    enable_sync_notification                       notification_conf['enable_sync_notification']
    enable_smtp_authentication                     notification_conf['enable_smtp_authentication']
    enable_status_notification                     notification_conf['enable_status_notification']
    language                                       notification_conf['language']
    properties                                     notification_conf['properties']
    sender_address                                 notification_conf['sender_address']
    sender_name                                    notification_conf['sender_name']
    smtp_host                                      notification_conf['smtp_host']
    smtp_password                                  notification_conf['smtp_password']
    smtp_port                                      notification_conf['smtp_port']
    smtp_user                                      notification_conf['smtp_user']
    status_notification_frequency                  notification_conf['status_notification_frequency']
    status_notification_time                       notification_conf['status_notification_time']
  end
end
