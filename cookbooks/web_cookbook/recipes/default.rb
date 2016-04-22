#
# Cookbook Name:: web_cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node.role?('nginx')
   include_recipe 'web_nginx'

elsif node.role?('httpd')
   include_recipe 'web_apache'

end
