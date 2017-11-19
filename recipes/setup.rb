#
# Cookbook:: tomcat
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'java-1.7.0-openjdk-devel' 

group 'tomcat' do
  append true
end

user 'tomcat' do
  group 'tomcat'
  home '/opt/tomcat'
  shell '/bin/nologin'
  manage_home false
end

directory '/opt/tomcat' do
  action :create
end 

remote_file 'apache-tomcat-8.5.23.tar.gz' do
  source 'http://supergsego.com/apache/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz'
#  owner 'web_admin'
#  group 'web_admin'
#  mode '0755'
  action :create
end

execute 'unzip tar' do
  command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
end

#directory 'opt/tomcat' do
#  group 'tomcat'
#end

execute 'change group recursively' do
  command 'chgrp -R tomcat /opt/tomcat'
end

execute 'update mode recursively on conf' do
  command 'chmod -R g+r /opt/tomcat/conf'
end

directory 'opt/tomcat/conf' do
  mode '0750'
end

execute 'chown for some sub directories within tomcat' do
  command 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
end

template '/etc/systemd/system/tomcat.service' do
  source 'systemd.erb'
end
	
execute 'daemon reload' do
  command 'systemctl daemon-reload'
end

service 'tomcat' do
  action [:start, :enable]
end
