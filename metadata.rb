name             'wsus-server'
maintainer       'Criteo'
maintainer_email 'b.courtois@criteo.com'
license          'Apache 2.0'
description      'Installs wsus server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.5'
supports         'windows'
depends          'windows'

chef_version '>= 11.12' if respond_to?(:chef_version)
source_url 'https://github.com/criteo-cookbooks/wsus-server' if respond_to?(:source_url)
issues_url 'https://github.com/criteo-cookbooks/wsus-server/issues' if respond_to?(:issues_url)
