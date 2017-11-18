describe file('java-1.7.0-openjdk-devel') do
 it { should exist }
end

#describe file('/etc/yum.repos.d/mongodb-org-3.4.repo') do
# its ( 'size') { should_not be 0 }
#end

#describe package('mongodb-org') do
#  it { should be_installed }
#end

#describe service ('mongod') do
#  it { should be_running }
#end

#describe file('/var/log/mongodb/mongod.log') do
#  its ('content') { should match /waiting for connections/ }
#end

