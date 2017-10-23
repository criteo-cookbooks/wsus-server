Wsus-server CHANGELOG
==============
This file is used to list changes made in each version of the wsus-server cookbook.

2.2.0 (2017-10-23)
------------------
- [PR 29](https://github.com/criteo-cookbooks/wsus-server/pull/29) - Make providers Chef13 compatible - Thanks @knightorc
- Do not install all UpdateService subfeatures

2.1.0 (2017-05-23)
------------------
- [PR 24](https://github.com/criteo-cookbooks/wsus-server/pull/24) - Install Report Viewer 2012

2.0.0 (2017-04-26)
------------------
- Requires at least chef 12.1
- [PR 22](https://github.com/criteo-cookbooks/wsus-server/pull/22) - Fix compatibility with cookbook windows 3.0 - Thanks @Stromweld
- [PR 20](https://github.com/criteo-cookbooks/wsus-server/pull/20) - Enable WCF-HTTP-Activation on Server 2012R2

1.0.5 (2016-07-21)
------------------
- [PR 19](https://github.com/criteo-cookbooks/wsus-server/pull/19) - Fix powershell binary path using locate_sysnative helper - Thanks @jmunnik
- [PR 15](https://github.com/criteo-cookbooks/wsus-server/pull/15) - Add a timeout on subscription configuration - Thanks @martinheg
- [PR 14](https://github.com/criteo-cookbooks/wsus-server/pull/14) - Fix description of synchronize_categories in README.md - Thanks @martinheg

1.0.4 (2015-11-24)
------------------
- [PR 9](https://github.com/criteo-cookbooks/wsus-server/pull/9) - Fix Windows feature activation using powershell provider - Thanks @Vladyslav-M

1.0.3 (2015-11-16)
------------------
-  Fix option SQL_INSTANCE_NAME for windows 2012R2 - Thanks @jmunnik

1.0.2 (2014-04-30)
------------------
- [PR 6](https://github.com/criteo-cookbooks/wsus-server/pull/6) - Fix bugs in freeze recipe

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
