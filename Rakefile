#!/usr/bin/env rake

require 'foodcritic'
require 'kitchen'

FoodCritic::Rake::LintTask.new
desc 'Run kitchen tests'
task :test_ec2 do
  Kitchen.logger = Kitchen.default_file_logger
  @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.ec2.yml')
  config = Kitchen::Config.new(loader: @loader)
  if ENV['KITCHEN_NO_CONCURRENCY']
    config.instances.each do |instance|
      instance.test(:always)
    end
  else
    threads = []
    config.instances.each do |instance|
      threads << Thread.new { instance.test(:always) }
    end
    threads.map(&:join)
  end
end
task default: [:foodcritic, :test_ec2]
