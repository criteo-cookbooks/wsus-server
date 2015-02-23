require 'spec_helper'

describe 'wsus-server::report_viewer' do
  describe 'On windows' do
    it 'installs the report viewer' do
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to install_windows_package('Microsoft Report Viewer Redistributable 2008 SP1')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
