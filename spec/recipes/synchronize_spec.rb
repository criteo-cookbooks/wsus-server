require 'spec_helper'

describe 'wsus-server::synchronize' do
  describe 'On windows' do
    it 'installs WSUS server' do
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::install')
      end
    end

    it 'synchronizes updates' do
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to run_powershell_script('WSUS Update Synchronization')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
