#
# Cookbook Name:: myjboss
# Recipe:: default
#

include_recipe 'java'
#Yum
yum_package 'unzip' do
  action :install
end 
#User
user node['jboss']['jboss_user'] do
  comment 'jboss user'
  home node['jboss']['jboss_home']
  system true
  shell '/bin/bash'
end
#Group
group node['jboss']['jboss_group'] do
  action :create
end
#JBoss
remote_file "#{ node['jboss']['target_dir'] }/jboss-5.1.0.GA.zip" do
  source node['jboss']['url']
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  mode '0755'
  action :create 
end
#Extract JBoss
execute 'extract_jboss' do
  command 'unzip jboss-5.1.0.GA.zip'
  cwd node['jboss']['target_dir']
end
#APP
remote_file "#{ node['jboss']['target_dir'] }/testweb.zip" do
  source node['jboss']['app_url']
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  mode '0755'
  action :create
end
#Extract app 
execute 'extract_testweb_zipfile' do
  command "unzip testweb.zip -d #{ node['jboss']['deploy_path'] }"
  cwd node['jboss']['target_dir']
  not_if { File.directory?( "#{ node['jboss']['deploy_path']}/testweb" ) }
end
#Init JBoss
template "/etc/init.d/jboss" do
  source "jboss.erb"
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
     :jboss_user => node['jboss']['jboss_user'],
     :jboss_home => node['jboss']['jboss_home'],
     :bind_address => node['jboss']['bind_address']
  })
end
#Owner
execute 'jboss folder ownership' do
  command "chown -R #{ node['jboss']['jboss_user'] }:#{ node['jboss']['jboss_group'] } #{ node['jboss']['jboss_home'] }"
end

#Service
service 'jboss' do
  init_command "/etc/init.d/jboss"
  supports :restart => true, :status => true, :stop => true
  action [ :enable, :start ]
end



