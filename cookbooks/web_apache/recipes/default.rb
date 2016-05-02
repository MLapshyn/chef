#
# Cookbook Name:: web_apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

web_cookbook "install httpd" do
  action :install
  provider "web_apache"
end

web_cookbook "setup default page" do
  action :setup
  provider "web_apache"
end
