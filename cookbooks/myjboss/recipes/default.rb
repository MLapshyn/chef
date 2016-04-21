#
# Cookbook Name:: myjboss
# Recipe:: default
#
# Copyright 2016, Maksim_Lapshyn
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'
#Installig yum
yum_package 'unzip' do
  action :install
end
#USER
user node['jboss']['jboss_user'] do
  comment 'jboss user'
  home node['jboss']['jboss_home']
  system true
  shell '/bin/bash'
end
#GROUP
group node['jboss']['jboss_group'] do
  action :create
end
#Download JBoss
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
#EXECUTE APP 
execute 'extract_testweb_zipfile' do
  command "unzip testweb.zip -d #{ node['jboss']['deploy_path'] }"
  cwd node['jboss']['target_dir']
  not_if { File.directory?( "#{ node['jboss']['deploy_path']}/testweb" ) }
end
hudson_xml = data_bag_item('jboss_databag', 'databag_for_hudson')

template "#{node['jboss']['deploy_path']}/#{node['jboss']['app_name']}.xml" do
  source "hudson.erb"
  owner 'jboss'
  group 'jboss'
  mode '0755'
  variables({
    :engine => hudson_xml['cumulogic-app']['services']['framework']['engine']
  })
end
#INIT JBoss
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
#OWNER
execute 'jboss folder ownership' do
  command "chown -R #{ node['jboss']['jboss_user'] }:#{ node['jboss']['jboss_group'] } #{ node['jboss']['jboss_home'] }"
end

service 'jboss' do
  init_command "/etc/init.d/jboss"
  supports :restart => true, :status => true, :stop => true
  action [ :enable, :start ]
end



