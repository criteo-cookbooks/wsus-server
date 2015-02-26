Wsus-server CHANGELOG
==============
This file is used to list changes made in each version of the wsus-server cookbook.

1.0.1 (2014-02-26)
------------------
- [PR 5](https://github.com/criteo-cookbooks/wsus-server/pull/5) - Fix property hash initialization

1.0.0 (2014-02-24)
------------------
- Supports Windows Server 2012 properly
- Fix powershell execution on x64 node
- Remove dependency on iis and powershell cookbooks
- Depends on Chef 11.12.0+
- Add Chefspec tests and proper documentation

0.1.0 (2014-08-27)
------------------
- Initial release of wsus-server
- Server recipes do nothing on non-windows platform
- Add recipe to install Microsoft Report Viewer Redistributable 2008 SP1 (WSUS prerequist)
- Add server recipe that install WSUS 3.0 SP2
- Add new recipe server_configuration to configure WSUS and its notification and subscription settings.
- Add new LWRP wsus_server to configure WSUS main settings.
- Add new LWRP wsus_subscription to configure WSUS update subscription.
- Add new LWRP wsus_notification to configure WSUS e-mail notification.
