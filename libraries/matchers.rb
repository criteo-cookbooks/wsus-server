if defined?(ChefSpec)
  ChefSpec.define_matcher :wsus_server_configuration
  def configure_wsus_server_configuration(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:wsus_server_configuration, :configure, resource)
  end

  ChefSpec.define_matcher :wsus_server_notification
  def configure_wsus_server_notification(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:wsus_server_notification, :configure, resource)
  end

  ChefSpec.define_matcher :wsus_server_subscription
  def configure_wsus_server_subscription(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:wsus_server_subscription, :configure, resource)
  end
end
