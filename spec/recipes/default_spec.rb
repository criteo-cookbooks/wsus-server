require 'spec_helper'

describe 'wsus-server::default' do
  describe 'On windows' do
    it 'installs wsus server' do
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::install')
      end
    end
    it 'synchronizes wsus server' do
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::synchronize')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
