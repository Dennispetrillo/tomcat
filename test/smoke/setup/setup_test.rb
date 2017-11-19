describe package('java-1.7.0-openjdk-devel') do
 it { should be_installed }
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  its('group') { should eq 'tomcat' }
end

describe user('tomcat') do
  its('shell') { should eq '/bin/nologin' } 
end

describe directory('/opt/tomcat') do
  it { should exist }
end

describe file('/apache-tomcat-8.5.23.tar.gz') do
  it { should exist }
end

#describe directory('opt/tomcat') do
#  its('group') {should eq 'tomcat' }
#end

#describe file('opt/tomcat/conf') do
#  its('mode') { should cmp '00740' }
#end
  

