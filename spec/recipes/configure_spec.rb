require 'spec_helper'

describe 'wsus-server::configure' do
  describe 'On windows' do
    it 'installs wsus server' do
      [windows2016_chef_run, windows2016_chef_run].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::install')
      end
    end

    it 'configures wsus server' do
      [windows2016_chef_run, windows2016_chef_run].each do |chef_run|
        expect(chef_run).to configure_wsus_server_configuration('Wsus server configuration')
        expect(chef_run).to configure_wsus_server_notification('Wsus server notification')
      end
    end

    it 'configures wsus server subscription' do
      [windows2016_chef_run, windows2016_chef_run].each do |chef_run|
        expect(chef_run).to configure_wsus_server_subscription('Wsus server subscription')
      end
    end

    it 'configures wsus server notification' do
      [windows2016_chef_run, windows2016_chef_run].each do |chef_run|
        expect(chef_run).to configure_wsus_server_notification('Wsus server notification')
      end
    end

    let(:wsus_replica_conf) { { wsus_server: { configuration: { IsReplicaServer: true, master_server: 'http://127.0.0.1' } } } }
    it 'does not configure subscription on replica server' do
      [windows2016_chef_run(wsus_replica_conf), windows2019_chef_run(wsus_replica_conf)].each do |chef_run|
        expect(chef_run).to_not configure_wsus_server_subscription('Wsus server subscription')
      end
    end

    it 'does not configure notification on replica server' do
      [windows2016_chef_run(wsus_replica_conf), windows2019_chef_run(wsus_replica_conf)].each do |chef_run|
        expect(chef_run).to_not configure_wsus_server_notification('Wsus server notification')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
