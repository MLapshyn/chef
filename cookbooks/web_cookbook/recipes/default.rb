#
# Cookbook Name:: web_cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node.role?('nginx')
     web 'Installing nginx' do
   provider 'web_nginx'
   action:install
end
elsif node.role?('apache')
     web 'Installing apache' do
   provider 'web_apache'
   action:install
end
