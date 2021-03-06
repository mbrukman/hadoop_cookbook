require 'spec_helper'

describe 'hadoop::hadoop_yarn_nodemanager' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'install hadoop-yarn-nodemanager package' do
      expect(chef_run).to install_package('hadoop-yarn-nodemanager')
    end

    it 'ensures /usr/lib/hadoop-yarn/bin/container-executor has proper permissions' do
      expect(chef_run).to create_file('/usr/lib/hadoop-yarn/bin/container-executor').with(
        user: 'root',
        group: 'yarn',
        mode: '6050'
      )
    end

    it 'creates hadoop-yarn-nodemanager service resource, but does not run it' do
      expect(chef_run).to_not start_service('hadoop-yarn-nodemanager')
    end
  end
end
