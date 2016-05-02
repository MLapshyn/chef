#
# Cookbook Name:: web_nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

web_cookbook "install nginx" do
  action :install
  provider "web_nginx"
end

web_cookbook "setup default page" do
  action :setup
  provider "web_nginx"
end
