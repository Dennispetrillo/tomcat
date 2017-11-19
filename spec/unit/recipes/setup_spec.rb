#
# Cookbook:: tomcat
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::setup' do
  context 'When all attributes are default, on an redhat 7.4' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.4')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs java' do
      expect(chef_run).to install_package('java-1.7.0-openjdk-devel')
    end

    it 'creates a group with the default action' do
      expect(chef_run).to create_group('tomcat').with(append: true)
    end

    it 'creates a user with attributes' do
      expect(chef_run).to create_user('tomcat').with(group: 'tomcat')
      expect(chef_run).to create_user('tomcat').with(home: '/opt/tomcat')
      expect(chef_run).to create_user('tomcat').with(shell: '/bin/nologin')
      expect(chef_run).to create_user('tomcat').with(manage_home: false)	
    end

    it 'creates a directory with the default action' do
      expect(chef_run).to create_directory('/opt/tomcat')
    end

     it 'creates a remote_file with the default action' do
      expect(chef_run).to create_remote_file('apache-tomcat-8.5.23.tar.gz')
     end

     it 'executes unzip tar' do
      expect(chef_run).to run_execute('tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1')
     end

     it 'changes group recursively' do
      expect(chef_run).to run_execute('chgrp -R tomcat /opt/tomcat')
     end

    it 'updates mode recursively on conf' do
      expect(chef_run).to run_execute('chmod -R g+r /opt/tomcat/conf')
    end

    it 'chowns for select sub directories within tomcat' do
     expect(chef_run).to run_execute('chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/')
    end

   it 'reloads daemon' do
     expect(chef_run).to run_execute('systemctl daemon-reload')
    end

   it 'enables the tomcat service' do
     expect(chef_run).to enable_service('tomcat')
     expect(chef_run).to start_service('tomcat')
   end
 end
end
