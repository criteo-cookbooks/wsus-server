require 'spec_helper'

describe 'wsus-server::freeze' do
  describe 'On windows' do
    def stub_powershell_guard(result=true)
      stub_command("      [Reflection.Assembly]::LoadWithPartialName('Microsoft.UpdateServices.Administration') | Out-Null\n      $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()\n      ($wsus.GetComputerTargetGroups() | where Name -eq '') -eq $null\n").and_return(result)
    end

    it 'installs WSUS server' do
      stub_powershell_guard
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to include_recipe('wsus-server::install')
      end
    end

    it 'freezes updates when target group does not exist' do
      stub_powershell_guard(true)
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to run_powershell_script('WSUS Update Freeze')
      end
    end

    it 'does not freeze updates when target group already exist' do
      stub_powershell_guard(false)
      [windows2008_chef_run, windows2008_chef_run].each do |chef_run|
        expect(chef_run).to_not run_powershell_script('WSUS Update Freeze')
      end
    end
  end

  describe 'On linux' do
    it 'does nothing' do
      expect(linux_chef_run.resource_collection).to be_empty
    end
  end
end
