Wsus-server Cookbook
=============
[![Cookbook Version][cookbook_version]][cookbook]
[![Build Status][build_status]][build_status]
[![License][license]][license]

Installs WSUS (Windows Server Update Services) and configure approved updates.

Requirements
------------
This cookbook requires Chef 12.1+.

### Platforms
* Windows Server 2008 (R1, R2)
* Windows Server 2012 (R1, R2)

### Cookbooks
The following cookbooks are required as noted:

* [windows][windows_cookbook] (`wsus-server::install` leverages windows_package and windows_feature LWRPs)

Usage
-----
Place an explicit dependency on this cookbook (using depends in the cookbook's metadata.rb) from any cookbook where you would like to use the Wsus-Server-specific resources/providers that ship with this cookbook.

```ruby
depends 'wsus-server'
```

Then include the recipes you want, or use one the LWRP provided.


Providers & Resources
---------------------
## wsus_server_configuration
Resource provider for configuring WSUS server global settings, for example specify a proxy server if necessary, the update languages to download, and whether the updates are stored locally.
This is a mapping of the [IUpdateServerConfiguration][configuration] interface.

### Attributes
Attribute        | Description                         | Type
-----------------|-------------------------------------|-----
name             | Name of the resource                | String
endpoint         | Url of the server to configure      | String, URI
master_server    | Url of the upstream server          | String, URI
proxy_password   | Password to access the proxy server | String
properties       | Hash to configure all [IUpdateServerConfiguration][configuration_members] writeable properties | Hash
update_languages | Update languages to download        | Array

## wsus_server_notification
Resource provider for configuring WSUS notifications and e-mail settings, such as user account and e-mail server.
This is a mapping of the [IEmailNotificationConfiguration][notification] interface.

### Attributes
Attribute                     | Description                                              | Type
------------------------------|----------------------------------------------------------|-----
name                          | Name of the resource                                     | String
endpoint                      | Url of the server to configure                           | String, URI
enable_sync_notification      | Whether update alerts should be sent                     | TrueClass, FalseClass
enable_smtp_authentication    | Whether the SMTP server requires authentication          | TrueClass, FalseClass
enable_status_notification    | Whether new update status summaries are to be sent       | TrueClass, FalseClass
language                      | Language used in the e-mail                              | String
properties                    | Hash to configure all [IEmailNotificationConfiguration][notification_members] writeable properties | Hash
sender_address                | E-mail address of the sender                             | String
sender_name                   | Display name of the e-mail sender                        | String
smtp_host                     | Password of the e-mail sender                            | String
smtp_password                 | Name of the SMTP server                                  | String
smtp_port                     | SMTP port number                                         | FixNum
smtp_user                     | Username of the e-mail sender                            | String
status_notification_frequency | Frequency with which e-mail notifications should be sent | String
status_notification_time      | Time of the day e-mail notifications should be sent      | String

## wsus_server_subscription
Resource provider for configuring WSUS synchronization settings.
This is a mapping of the [ISubscription][subscription] interface.

### Attributes
Attribute                | Description                                       | Type
-------------------------|---------------------------------------------------|-----
name                     | Name of the resource                              | String
endpoint                 | Url of the server to configure                    | String, URI
automatic_synchronization| Whether to automatically synchronizes updates     | TrueClass, FalseClass
categories               | Categories of updates that WSUS synchronizes      | Array
classifications          | Classifications of updates that WSUS synchronizes | Array
properties               | Hash to configure all [ISubscription][subscription_members] writeable properties | Hash
synchronization_per_day  | Number of server-to-server synchronizations a day | FixNum
synchronization_time     | Time of day to automatically synchronize updates  | String
synchronize_categories   | Whether to only synchronize categories not updates| TrueClass, FalseClass
configure_timeout        | Timeout in seconds for subscription configuration | FixNum

Recipes
-------
All recipes described below are configurable via attributes, as described in the previous section.

## wsus-server::configure
This is the main recipe to configure WSUS servers.
It configures the service itself - upstream server, listening port, etc. - but also subscriptions and notifications

### Attributes
The following attributes are used to configure the `wsus-server::configure` recipe.

#### WSUS global settings
Accessible via `node['wsus_server']['configuration']`.

Attribute                | Description                                                          | Type        | Default
-------------------------|----------------------------------------------------------------------|-------------|--------
proxy_password           | Password to use when accessing the proxy server                      | String      | `nil`
update_languages         | Enables update for the specified list of languages                   | Array       | `['en']`
master_server            | Defines the upstream server and set the current server as its replica| String, URI | `nil`
properties               | Hash to configure all [IUpdateServerConfiguration][configuration_members] writeable properties | Hash | `{ 'TargetingMode' => 'Client' }`


#### WSUS notification settings
Accessible via `node['wsus_server']['notification']`.

Attribute                    | Description                                             | Type                  | Default
-----------------------------|---------------------------------------------------------|-----------------------|--------
enable_sync_notification     | Whether new update alerts should be sent                | TrueClass, FalseClass | `false`
enable_smtp_authentication   | Whether the SMTP server requires authentication         | TrueClass, FalseClass | `false`
enable_status_notification   | Whether the new update status summaries should be send  | TrueClass, FalseClass | `false`
language                     | Language used to send notification e-mails              | String                | `en`
properties                   | Hash to configure all [ISubscription][subscription_members] writeable properties | Hash | `{}`
sender_address               | E-mail address of the notification sender               | String                | `nil`
sender_name                  | Display name of the notification sender                 | String                | `nil`
smtp_host                    | Hostname of the SMTP server used by notifications       | String                | `nil`
smtp_password                | Time of day when WSUS synchronize updates and categories| String                | `nil`
smtp_port                    | port of the SMTP server used for notifications          | FixNum                | `25`
smtp_user                    | Username of the notification sender                     | String                | `nil`
status_notification_frequency| E-mail notification frequency (`Daily` or `Weekly`)     | String                | `Daily`
status_notification_time     | Time of the day e-mail notifications should be sent     | String                | `00:00:00`


#### WSUS synchronization settings
Accessible via `node['wsus_server']['subscription']`.

Attribute                 | Description                                                | Type                  | Default
--------------------------|------------------------------------------------------------|-----------------------|--------
automatic_synchronization | Controls automatic updates synchronization                 | TrueClass, FalseClass | `true`
categories                | List of update categories to synchronize (ID or Title)     | Array                 | `[]`
classifications           | List of update classifications to synchronize (ID or Title)| Array                 | `[]`
properties                | Hash to configure all [ISubscription][subscription_members] writeable properties | Hash | `{}`
synchronization_per_day   | Number of server-to-server synchronizations a day          | FixNum                | `12`
synchronization_time      | Time of day when WSUS synchronize updates and categories   | String                | `00:00:00`
synchronize_categories    | Synchronizes categories before configuring other settings  | TrueClass, FalseClass | `true`
configure_timeout         | Timeout in seconds for subscription configuration          | FixNum                | `900`


## wsus-server::default
Convenience recipe that installs and configures latest WSUS then synchronizes updates.
It basicly includes `wsus-server::install` and `wsus-server::synchronize`

## wsus-server::freeze
Convenience recipe that tries to create a new Computer target group then approves all available updates for this specific group.

### Attributes
Accessible via `node['wsus_server']['freeze']`.

Attribute | Description                                               | Type   | Default
----------|-----------------------------------------------------------|--------|--------
name      | Name of the frozen update list (computer group) to create | String | `nil`

## wsus-server::install
This recipe can be included in a node's run_list to installs the latest available Windows Server Update Services.
On Windows Server 2008 and 2008R2 it leverages the `windows_package` LWRP to installs WSUS 3.0 SP2
On Windows Server 2012 and 2012R2 it leverages the `windows_feature` LWRP to enable WSUS 4.0.

In order to setup WSUS services properly it also enables some IIS components.

### Attributes
Accessible via `node['wsus_server']['setup']`

Attribute       | Description                                        | Type   | Default
----------------|----------------------------------------------------|--------|--------
content_dir     | Directory to store localy WSUS content             | String | `nil`
sqlinstance_name| Local or remote SQL instance for WSUS configuration| String | `nil`

#### More Setup attributes for Windows Server 2008R2 and earlier
Accessible via `node['wsus_server']['setup']`

Attribute               | Description                                        | Type   | Default
------------------------|----------------------------------------------------|--------|--------
enable_inventory        | Enables the inventory feature                      | TrueClass, FalseClass | `false`
frontend_setup          | Whether WSUS should be setup as an additional [frontend server][frontend_server]| TrueClass, FalseClass | `false`
join_improvement_program| Joins the Microsoft Update Improvement Program     | TrueClass, FalseClass | `false`
use_default_website     | Whether WSUS should be set as default website - port 80 instead of 8530 | TrueClass, FalseClass | `false`
wyukon_data_dir         | Path to windows internal database data directory   | String | `nil`

#### Package attributes for Windows Server 2008R2 and earlier
Accessible via `node['wsus_server']['package']`

Attribute | Description                                        | Type   | Default
----------|----------------------------------------------------|--------|--------
name      | Name of the windows package                        | String | `Microsoft Server Update Services 3.0 SP2`
source    | Source of the windows package                      | String | *depends of the architecture*
checksum  | Checksum of the windows package                    | String | *depends of the architecture*
options   | Options to use when installing the windows package | String | `/q`

## wsus-server::report_viewer
Install reporting viewer 2012 to enable wsus reports.

### Attributes
Attributes to configure Reportviewer prerequisite package are accessible via `node['wsus_server']['report_viewer']['prerequisite']`.

Attribute | Description                                        | Type   | Default
----------|----------------------------------------------------|--------|--------
name      | Name of the windows package                        | String | `Microsoft System CLR Types for SQL Server 2012 (x64)`
source    | Source of the windows package                      | String | [https://download.microsoft.com/.../SQLSysClrTypes.msi][sql_clr_types]
checksum  | Checksum of the windows package                    | String | `674c396e9c9bf389dd21c...c570fa927b07fa620db7d4537`
options   | Options to use when installing the windows package | String | `/q`

Attributes to configure Reportviewer runtime package are accessible via `node['wsus_server']['report_viewer']['runtime']`.

Attribute | Description                                        | Type   | Default
----------|----------------------------------------------------|--------|--------
name      | Name of the windows package                        | String | `Microsoft Report Viewer 2012 Runtime`
source    | Source of the windows package                      | String | [https://download.microsoft.com/.../ReportViewer.exe][report_viewer]
checksum  | Checksum of the windows package                    | String | `948f28452abddd90b27dc...d42254c71b5b1e19ac5c6daf`
options   | Options to use when installing the windows package | String | `/q`

## wsus-server::synchronize
This recipe performs a synchronous update of the update catalog, according to the configured subscriptions.

### Attributes
Accessible via `node['wsus_server']['synchronize']`.

Attribute | Description                                        | Type   | Default
----------|----------------------------------------------------|--------|--------
timeout   | Synchronization timeout in minutes<br/>(zero or negative value for asynchronous synchronization) | FixNum | `60`

Contributing
------------
1. Fork the [repository on Github][repository]
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

*NB.* do not change the version in the metadata nor update the changelog. This'll be done by one of the cookbook maintainer.

License and Authors
-------------------
Authors: [Baptiste Courtois][author] (<b.courtois@criteo.com>)

```text
Copyright 2014, Criteo.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[author]:                https://github.com/Annih
[repository]:            https://github.com/criteo-cookbooks/wsus-server
[windows_cookbook]:      https://community.opscode.com/cookbooks/windows/
[configuration]:         http://msdn.microsoft.com/library/microsoft.updateservices.administration.iupdateserverconfiguration
[configuration_members]: http://msdn.microsoft.com/library/microsoft.updateservices.administration.iupdateserverconfiguration_members
[notification]:          http://msdn.microsoft.com/library/microsoft.updateservices.administration.iemailnotificationconfiguration
[notification_members]:  http://msdn.microsoft.com/library/microsoft.updateservices.administration.iemailnotificationconfiguration_members
[subscription]:          http://msdn.microsoft.com/library/microsoft.updateservices.administration.isubscription
[subscription_members]:  http://msdn.microsoft.com/library/microsoft.updateservices.administration.isubscription_members
[frontend_server]: 		 http://technet.microsoft.com/library/dd939896
[report_viewer]:		 https://download.microsoft.com/download/F/B/7/FB728406-A1EE-4AB5-9C56-74EB8BDDF2FF/ReportViewer.msi
[sql_clr_types]:         https://download.microsoft.com/download/F/E/D/FEDB200F-DE2A-46D8-B661-D019DFE9D470/ENU/x64/SQLSysClrTypes.msi
[build_status]:          https://api.travis-ci.org/criteo-cookbooks/wsus-server.svg?branch=master
[cookbook_version]:      https://img.shields.io/cookbook/v/wsus-server.svg
[cookbook]:              https://supermarket.chef.io/cookbooks/wsus-server
[license]:               https://img.shields.io/github/license/criteo-cookbooks/wsus-server.svg
