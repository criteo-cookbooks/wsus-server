require 'spec_helper'

describe 'wsus-server::install' do
  describe 'On windows' do
    it 'creates the WSUS content directory when content_dir is provided' do
      conf = { wsus_server: { setup: { content_dir: 'content_dir' } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to create_directory('content_dir').with(recursive: true)
      end
    end
    it 'does not create the WSUS content directory when content_dir is not provided' do
      conf = { wsus_server: { setup: { content_dir: nil } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to_not create_directory('content_dir')
      end
    end
    it 'configures the WSUS server when frontend_setup is false' do
      conf = { wsus_server: { setup: { frontend_setup: false } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::configure')
      end
    end
    it 'does not configure the WSUS server when frontend_setup is true' do
      conf = { wsus_server: { setup: { frontend_setup: true } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to_not include_recipe('wsus-server::configure')
      end
    end
    it 'installs windows feature UpdateServices' do
      [windows2016_chef_run, windows2019_chef_run].each do |chef_run|
        expect(chef_run).to install_windows_feature('UpdateServices').with(all: true)
      end
    end
    it 'installs windows feature UpdateServices-UI' do
      [windows2016_chef_run, windows2019_chef_run].each do |chef_run|
        expect(chef_run).to install_windows_feature('UpdateServices-UI').with(all: true)
      end
    end
    it 'installs windows feature UpdateServices-WidDatabase when no sql_instance_name is provided' do
      conf = { wsus_server: { setup: { sqlinstance_name: nil } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to install_windows_feature('UpdateServices-WidDatabase').with(all: true)
        expect(chef_run).to remove_windows_feature('UpdateServices-Database').with(all: true)
      end
    end
    it 'installs windows feature UpdateServices-Database instead when sql_instance_name is provided' do
      conf = { wsus_server: { setup: { sqlinstance_name: 'instance' } } }
      [windows2016_chef_run(conf), windows2019_chef_run(conf)].each do |chef_run|
        expect(chef_run).to remove_windows_feature('UpdateServices-WidDatabase').with(all: true)
        expect(chef_run).to install_windows_feature('UpdateServices-Database').with(all: true)
      end
    end
    it 'executes WSUS PostInstall when there is no guard file' do
      [windows2016_chef_run, windows2019_chef_run].each do |chef_run|
        allow(::File).to receive(:exist?).and_call_original
        expect(::File).to receive(:exist?).with('/wsus_postinstall').and_return false
        expect(chef_run).to run_execute('WSUS PostInstall')
      end
    end
    it 'does not execute WSUS PostInstall when there is a guard file' do
      [windows2016_chef_run, windows2019_chef_run].each do |chef_run|
        allow(::File).to receive(:exist?).and_call_original
        expect(::File).to receive(:exist?).with('/wsus_postinstall').and_return true
        allow(::File).to receive(:read).and_call_original
        expect(::File).to receive(:read).with('/wsus_postinstall').and_return ''
        expect(chef_run).to_not run_execute('WSUS PostInstall')
      end
    end
    it 'creates WSUS PostInstall guard file' do
      [windows2016_chef_run, windows2019_chef_run].each do |chef_run|
        expect(chef_run).to create_file('/wsus_postinstall')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
