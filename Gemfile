source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'rspec-mocks'
  gem 'chefspec',   '>= 4.2'
  gem 'fauxhai',    '>= 2.2'
  gem 'foodcritic', '>= 4.0'
  gem 'berkshelf'
end

group :ec2 do
  gem 'test-kitchen'
  gem 'kitchen-ec2', :git => 'https://github.com/criteo-forks/kitchen-ec2.git', :branch => 'criteo'
  gem 'winrm',      '~> 1.6'
  gem 'winrm-fs',   '~> 0.3'
end
